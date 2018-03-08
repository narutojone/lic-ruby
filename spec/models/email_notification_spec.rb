# == Schema Information
#
# Table name: email_notifications
#
#  id                 :integer          not null, primary key
#  account_id         :integer          not null
#  template           :integer          default("new_ticket_when_assigned"), not null
#  enabled            :boolean          default(FALSE), not null
#  notifiable_role_id :integer
#  notifiable_user_id :integer
#  notify_assignee    :boolean          default(FALSE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  subject            :string           not null
#  text               :text             not null
#

require 'spec_helper'

RSpec.describe EmailNotification do
  let!(:email_notification) { FactoryBot.create(:email_notification) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(email_notification).to be_valid
    end

    it 'must have an account_id' do
      email_notification.account_id = nil
      expect(email_notification).to_not be_valid
    end

    it 'must have a template' do
      email_notification.template = nil
      expect(email_notification).to_not be_valid
    end

    it 'must have the enabled flag set' do
      email_notification.enabled = nil
      expect(email_notification).to_not be_valid
    end

    # it 'must have the notify_assignee flag set' do
    #   email_notification.notify_assignee = nil
    #   expect(email_notification).to_not be_valid
    # end

    it 'must have a subject' do
      email_notification.subject = ''
      expect(email_notification).to_not be_valid
    end

    it 'must have a text' do
      email_notification.text = ''
      expect(email_notification).to_not be_valid
    end

    # it 'must not let other accounts role to be set as notifiable_role' do
    #   other_accounts_role = FactoryBot.create(:role)
    #   email_notification.notifiable_role = other_accounts_role
    #   expect(email_notification).to_not be_valid
    #   expect(email_notification.errors.messages[:notifiable_role_id]).to be_present
    # end
    #
    # it 'must not let other accounts user to be set as notifiable_user' do
    #   other_accounts_user = FactoryBot.create(:user)
    #   email_notification.notifiable_user = other_accounts_user
    #   expect(email_notification).to_not be_valid
    #   expect(email_notification.errors.messages[:notifiable_user_id]).to be_present
    # end
    #
    # describe '#call_center_id' do
    #   it 'is optional' do
    #     email_notification.call_center_id = nil
    #     expect(email_notification).to be_valid
    #   end
    #
    #   it 'must belong to the same account' do
    #     other_call_center = FactoryBot.create(:call_center)
    #     email_notification.call_center = other_call_center
    #     expect(email_notification).to_not be_valid
    #     expect(email_notification.errors[:call_center_id]).to be_present
    #
    #     email_notification.call_center = email_notification.account.call_centers.first
    #     expect(email_notification).to be_valid
    #   end
    # end
  end

  describe ':text' do
    it 'gets sanitized when a value is assigned' do
      email_notification.text = '<p><a href="http://example.com">An example</a><br><script>alert("hello!");</script></p>'
      expect(email_notification.text).to eq('<p><a href="http://example.com">An example</a><br>alert("hello!");</p>')
    end
  end

end
