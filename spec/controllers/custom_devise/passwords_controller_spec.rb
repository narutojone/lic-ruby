require 'spec_helper'

describe CustomDevise::PasswordsController do
  render_views

  before do
    create_account

    @user = FactoryBot.create(:user, account: @account, email: 'jack.pot@example.com')
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  #----------------------------------------------------------------------------
  describe 'resetting your password' do
    it 'queues EmailNotifierJob' do
      expect(EmailNotifierJob).to receive(:perform_later).with(@user, EmailNotification.templates[:user_password_reset]).and_call_original
      post :create, params: {user: {account_id: @account.id, email: 'Jack.Pot@example.com'}}
    end

    it 'does not try to send a password reset email when the user is not found' do
      expect(EmailNotifierJob).not_to receive(:perform_later)
      post :create, params: {user: {account_id: @account.id, email: 'doesnotexist@example.com'}}
    end

    it 'redirects the user to login form and shows notice' do
      post :create, params: {user: {account_id: @account.id, email: 'jack.pot@example.com'}}
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:notice]).to be_present
    end

    it 'does not try to send a password reset email to a user from another account' do
      other_user = FactoryBot.create(:user, email: 'al.dente@example.com')

      expect(EmailNotifierJob).not_to receive(:perform_later)
      post :create, params: {user: {account_id: @account.id, email: 'al.dente@example.com'}}
    end
  end
end
