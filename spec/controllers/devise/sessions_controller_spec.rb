require 'spec_helper'

describe Devise::SessionsController do
  render_views

  before do
    create_account

    @user_with_pw    = FactoryBot.create(:user, account: @account, active: true, password: '123123123', password_confirmation: '123123123')
    @user_without_pw = FactoryBot.create(:user, account: @account, active: true, password: nil, password_confirmation: nil)

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.host = "#{@account.domain}.lvh.me"
  end

  #----------------------------------------------------------------------------
  describe '#create' do
    it 'logs in active user' do
      post :create, params: {user: {account_id: @account.id, email: @user_with_pw.email, password: '123123123'}}
      expect(response).to redirect_to(root_path)
    end

    it 'denies access to inactive user' do
      @user_with_pw.update!(active: false)

      post :create, params: {user: {account_id: @account.id, email: @user_with_pw.email, password: '123123123'}}

      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be_present
    end

    it 'does not log in active user without a password' do
      post :create, params: {user: {account_id: @account.id, email: @user_without_pw.email, password: ''}}

      expect(response).to render_template(:new)
      expect(flash[:alert]).to be_present
    end
  end
end
