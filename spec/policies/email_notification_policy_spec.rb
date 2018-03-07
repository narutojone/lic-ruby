require 'spec_helper'

describe EmailNotificationPolicy do

  before(:each) do
    @account = FactoryGirl.create(:account)
    @user = FactoryGirl.create(:user, account: @account)
    @email_notification = FactoryGirl.create(:email_notification, account: @account, template: 0)
  end

  subject { described_class }

  permissions :index? do
    it 'denies access if users role does not have email_notification:index permission' do
      expect(subject).not_to permit(@user, EmailNotification)
    end

    it 'grants access if users role has email_notification:index permission' do
      grant_permission(@user, 34)

      expect(subject).to permit(@user, EmailNotification)
    end
  end

  permissions :edit? do
    it 'calls update?' do
      expect_any_instance_of(subject).to receive(:update?)
      subject.new(@user, @email_notification).edit?
    end
  end

  permissions :update? do
    it 'denies access if users role does not have email_notification:update permission' do
      expect(subject).not_to permit(@user, @email_notification)
    end

    it 'grants access if users role has email_notification:update permission' do
      grant_permission(@user, 35)
      expect(subject).to permit(@user, @email_notification)
    end 
  end
end
