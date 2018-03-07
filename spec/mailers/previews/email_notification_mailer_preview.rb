class EmailNotificationMailerPreview < ActionMailer::Preview

  def new_ticket_when_assigned
    ticket = Ticket.assigned.first
    build_email(ticket, :new_ticket_when_assigned)
  end

  def new_ticket_when_unassigned
    ticket = Ticket.incoming.first
    build_email(ticket, :new_ticket_when_unassigned)
  end

  def new_ticket_closed
    ticket = Ticket.closed.first
    build_email(ticket, :new_ticket_closed)
  end

  def ticket_assigned
    ticket = Ticket.assigned.first
    build_email(ticket, :ticket_assigned)
  end

  def ticket_updated
    ticket = Ticket.assigned.first
    build_email(ticket, :ticket_updated)
  end

  def note_added_to_ticket
    ticket = Ticket.assigned.first
    build_email(ticket, :note_added_to_ticket)
  end

  def ticket_closed
    ticket = Ticket.closed.first
    build_email(ticket, :ticket_closed)
  end

  def excavator_notification_after_ticket_close
    ticket = Ticket.closed.first
    build_email(ticket, :excavator_notification_after_ticket_close)
  end

  def failed_audit_notification
    audit = Audit.where("missed_ticket_numbers <> '{}' OR missed_ticket_numbers IS NOT NULL").first
    build_email(audit, :failed_audit_notification)
  end

  def user_welcome
    user = User.first
    build_email(user, :user_welcome)
  end

  def user_password_reset
    user = User.first
    build_email(user, :user_password_reset)
  end

  private

  def build_email(object, notification_type)
    recipient = User.first
    notification = object.account.email_notifications.find_by(template: EmailNotification.templates[notification_type])
    header = object.account.email_header
    footer = object.account.email_footer

    EmailNotificationMailer.notification(
      recipient,
      get_converted_string(object, recipient, notification.subject),
      get_converted_string(object, recipient, notification.text),
      get_converted_string(object, recipient, header),
      get_converted_string(object, recipient, footer)
    )
  end

  def get_converted_string(object, recipient, str)
    notifier = EmailNotifier.new(object, nil)
    notifier.send(:convert_placeholders_to_data, recipient, str)
  end

end
