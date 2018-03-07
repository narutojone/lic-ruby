class EmailNotificationMailer < ApplicationMailer

  def notification(recipient, subject, email_text, header, footer)
    @subject    = subject
    @email_text = email_text
    @header     = header
    @footer     = footer

    mail(to: recipient.email, subject: subject, template_name: 'email_notification')
  end

end
