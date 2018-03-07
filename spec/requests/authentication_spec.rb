require 'spec_helper'

RSpec.describe 'Authentication' do

  before(:each) do
    @account = FactoryBot.create(:account)
    @admin = account_admin(@account)
    @user = FactoryBot.create(:user, account: @account, active: true, password: '123123123', password_confirmation: '123123123')
  end

  it 'successfully logs in an active user' do
    post '/users/sign_in', params: {user: {account_id: @account.id, email: @user.email, password: '123123123'}}
    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq('Signed in successfully.')
  end

  it 'will not allow an inactive user to log in' do
    @user.update(active: false)

    post '/users/sign_in', params: {user: {account_id: @account.id, email: @user.email, password: '123123123'}}
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to eq('Your account has been deactivated.')
  end
end
