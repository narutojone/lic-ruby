require 'spec_helper'

describe EmailNotificationsCreationJob do
  before do
    @account = FactoryGirl.create(:account)
    @call_center = @account.call_centers.first
    @call_center.email_notifications.delete_all
  end

  #----------------------------------------------------------------------------
  describe '#perform' do
    it 'adds all the call center specific email notifications to the call center' do
      expect {
        expect {
          EmailNotificationsCreationJob.perform_now(@call_center)
        }.to change { @call_center.email_notifications.count }.by(11)
      }.to change { @account.email_notifications.count }.by(11)

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:new_ticket_when_assigned])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['new_ticket_when_assigned']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['new_ticket_when_assigned']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:new_ticket_when_unassigned])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['new_ticket_when_unassigned']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['new_ticket_when_unassigned']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:new_ticket_closed])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['new_ticket_closed']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['new_ticket_closed']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:ticket_assigned])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['ticket_assigned']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['ticket_assigned']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:ticket_updated])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['ticket_updated']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['ticket_updated']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:note_added_to_ticket])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['note_added_to_ticket']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['note_added_to_ticket']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:ticket_closed])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['ticket_closed']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['ticket_closed']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:new_revised_ticket])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['new_revised_ticket']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['new_revised_ticket']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:new_emergency_ticket])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['new_emergency_ticket']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['new_emergency_ticket']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:failed_audit_notification])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['failed_audit_notification']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['failed_audit_notification']['text'])

      notif = @call_center.email_notifications.find_by(template: EmailNotification.templates[:excavator_notification_after_ticket_close])
      expect(notif).not_to be_enabled
      expect(notif.subject).to eq(EMAIL_NOTIFICATION_TEXTS['excavator_notification_after_ticket_close']['subject'])
      expect(notif.text).to eq(EMAIL_NOTIFICATION_TEXTS['excavator_notification_after_ticket_close']['text'])
    end

    it 'does not add user notifications' do
      EmailNotificationsCreationJob.perform_now(@call_center)

      EmailNotification::USER_TEMPLATES.each_value do |val|
        notif = @call_center.email_notifications.find_by(template: val)
        expect(notif).to be_nil
      end
    end
  end

end
