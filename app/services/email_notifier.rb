class EmailNotifier
  include ResponseCodesHelper
  include ActionView::Helpers::OutputSafetyHelper
  include Rails.application.routes.url_helpers

  def initialize(model, notification_template)
    @model        = model
    @account      = model.account
    @notification = @account.email_notifications.find_by(template: notification_template)
  end

  def notify
    return unless @notification && @notification.enabled?
    recipients.each { |user| send_notification(user) }

    if @model.is_a?(Ticket)
      EventLog.log_event(:email_notification, @model, @model, {template: @notification.template, recipient_emails: recipients.collect { |recp| recp.email }}) if recipients.any?
    end
  end

  private

  def recipients
    @recipients ||=
      begin
        users = []
        if @notification.excavator_notification_after_ticket_close?
          users << OpenStruct.new(email: @model.excavator_contact_email, first_name: '', name: @model.excavator_company_name) if @model.excavator_contact_email.present?
        elsif @notification.user_welcome? || @notification.user_password_reset?
          users << @model if @model.active?
        else
          users << @notification.notifiable_role.users.is_active if @notification.notifiable_role
          users << @notification.notifiable_user if @notification.notifiable_user && @notification.notifiable_user.active?
          if @model.is_a?(Ticket)
            users << @model.assignee if @notification.notify_assignee && @model.assignee && @model.assignee.active?
          end
          users.flatten!
          users.uniq!
        end
        users
      end
  end

  def send_notification(recipient)
    subject  = convert_placeholders_to_data(recipient, @notification.subject)
    text     = convert_placeholders_to_data(recipient, @notification.text)
    header   = convert_placeholders_to_data(recipient, @account.email_header)
    footer   = convert_placeholders_to_data(recipient, @account.email_footer)

    EmailNotificationMailer.notification(recipient, subject, text, header, footer).deliver_now
  end

  def convert_placeholders_to_data(recipient, template)
    str = template.gsub('{{recipient.first_name}}', recipient.first_name)
    str.gsub!('{{recipient.name}}', recipient.name)


    if @model.is_a?(Ticket)
      str.gsub!('{{ticket.url}}', ticket_url(@model, host: @model.account.full_domain, protocol: 'https'))
      str.gsub!('{{ticket.ticket_number}}', @model.ticket_number)
      str.gsub!('{{ticket.assignee.name}}', @model.assignee&.name.to_s)
      str.gsub!('{{ticket.work.address}}', @model.work_address)
      str.gsub!('{{ticket.caller.name}}', @model.caller_name.to_s)
      str.gsub!('{{ticket.caller.phone}}', @model.caller_phone.to_s)
      str.gsub!('{{ticket.locate_instructions}}', @model.locate_instructions.to_s)
      response_codes = ''
      if @model.ticket_responses.length > 0
        response_codes << @model.ticket_responses.collect do |response|
          "* #{response.service_area}: #{response_code_with_description(@model.call_center, response.code)}#{response.comment.present? ? " (#{response.comment})" : nil}"
        end.join('<br>')
      end
      str.gsub!('{{ticket.response_codes}}', response_codes)
    elsif @model.is_a?(Audit)
      str.gsub!("{{audit.url}}", audit_url(@model, host: @model.account.full_domain, protocol: 'https'))

      missed_ticket_numbers = @model.missed_ticket_numbers.map { |n| "* #{n}" }
      str.gsub!('{{audit.missed_ticket_numbers}}', "#{safe_join(missed_ticket_numbers, raw('<br/>'))}")
    elsif @model.is_a?(User)
      str.gsub!(
        '{{recipient.create_password_url}}',
        edit_user_password_url(host: @account.full_domain, protocol: 'https', reset_password_token: @model.send(:set_reset_password_token), create: true)
      ) if str.include?('{{recipient.create_password_url}}')

      str.gsub!(
        '{{recipient.reset_password_url}}',
        edit_user_password_url(host: @account.full_domain, protocol: 'https', reset_password_token: @model.send(:set_reset_password_token))
      ) if str.include?('{{recipient.reset_password_url}}')
    end

    boss811_logo_url = ApplicationController.helpers.image_url(
      'Boss811_blue.png',
      host: 'https://public.boss811.com'
    )

    boss811_logo_tag = ApplicationController.helpers.image_tag(
      boss811_logo_url,
      alt:    'Boss811 Logo',
      height: 30,
      class:  'logo',
      style:  'display: block;'
    )

    str.gsub!('{{boss811.logo}}', boss811_logo_tag)
    str.gsub!('{{company.name}}', @account.name.to_s)
    str.gsub!('{{company.logo}}', ApplicationController.helpers.image_tag(@account.logo.url(:medium), alt: 'Account Logo'))
    str.gsub!('{{company.boss811_url}}', root_url(host: @account.full_domain, protocol: 'https'))

    str
  end
end
