# == Schema Information
#
# Table name: email_notifications
#
#  id                 :integer          not null, primary key
#  account_id         :integer          not null
#  template           :integer          default(0), not null
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

RSpec.describe EmailNotificationsController do
  render_views

  before(:each) do
    create_account_and_login

    @role = FactoryBot.create(:role, account: @account)
    @email_notification = FactoryBot.create :email_notification,
                                             account: @account,
                                             notifiable_role: @role,
                                             notifiable_user: @admin
  end

  #----------------------------------------------------------------------------
  describe '#index' do
    it 'renders page' do
      get :index

      expect(response).to have_http_status(:success)
      expect(response.body).to match /Notifications/
    end
  end

  #----------------------------------------------------------------------------
  describe '#edit' do
    it 'renders page' do
      get :edit, params: {id: @email_notification.id}

      expect(response).to have_http_status(:success)
      expect(response.body).to match(/otification/)
    end
  end

  #----------------------------------------------------------------------------
  describe '#update' do
    it 'renders page and redirects user to edit' do
      patch :update, params: {id: @email_notification.id, email_notification: { subject: 'Haha' }}
      @email_notification.reload

      expect(response).to have_http_status(:redirect)
      expect(@email_notification.subject).to eq('Haha')
    end
  end
end
