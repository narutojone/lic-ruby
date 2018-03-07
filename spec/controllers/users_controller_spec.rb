# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  account_id             :integer          not null
#  email                  :string           not null
#  encrypted_password     :string           not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  api_key                :string
#  time_zone              :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active                 :boolean          default(TRUE), not null
#

require 'spec_helper'

describe UsersController do
  render_views

  before do
    create_account_and_login(time_zone: 'Eastern Time (US & Canada)')
    @user = FactoryBot.create :user,
                               account: @account,
                               first_name: 'Account',
                               last_name: 'User'
  end

  #----------------------------------------------------------------------------
  describe '#index' do
    before do
      @bill = FactoryBot.create(:user, account: @account, first_name: 'Billy', last_name: 'Baaaaaaaa')
      @joe =  FactoryBot.create(:user, account: @account, first_name: 'Joe', last_name: 'Schmoe')
      @jill = FactoryBot.create(:user, account: @account, first_name: 'Jilly', last_name: 'Abbbbbbbb')
    end

    it 'uses ransack search for @users' do
      get :index, params: {q: {first_name_or_last_name_cont: 'lly'}}
      expect(assigns(:users)).to eq([@jill, @bill]) # ordered
    end
  end

  #----------------------------------------------------------------------------
  describe '#show' do
    it 'loads users assigned tickets' do
      t1 = FactoryBot.create(:ticket, account: @account)
      t2 = FactoryBot.create(:assigned_ticket, account: @account, assignee: @user)
      t2.update_column(:response_due_at, Time.now + 1.day)
      t3 = FactoryBot.create(:assigned_ticket, account: @account)
      t3.update_column(:response_due_at, Time.now + 2.day)
      t4 = FactoryBot.create(:assigned_ticket, account: @account, assignee: @user)
      t4.update_column(:response_due_at, Time.now + 1.hour)
      t5 = FactoryBot.create(:closed_ticket, account: @account, assignee: @user)

      get :show, params: {id: @user.id}
      tickets = assigns(:tickets)
      expect(tickets.length).to eq(2)
      expect(tickets[0]).to eq(t4)
      expect(tickets[1]).to eq(t2)
    end

    it 'loads user through set_user' do
      expect(controller).to receive(:set_user).and_call_original
      expect(User).to_not receive(:find)
      get :show, params: {id: @user.id}
    end
  end

  #----------------------------------------------------------------------------
  describe '#new' do
    it 'renders page and returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'should build a new user and set proper timezone' do
      get :new

      expect(assigns(:user)).not_to be_nil
      expect(assigns(:user).time_zone).to eq('Eastern Time (US & Canada)')
    end
  end

  #----------------------------------------------------------------------------
  describe '#create' do
    it 'creates the user under the current account' do
      expect {
        post :create, params: {user: FactoryBot.attributes_for(:user)}
      }.to change{ @account.users.count }.by(1)
    end

    it 'sends :user_welcome email notification to the new user' do
      expect(EmailNotifierJob).to receive(:perform_later).with(an_instance_of(User), EmailNotification.templates[:user_welcome])

      post :create, params: {user: FactoryBot.attributes_for(:user)}
    end

    it 'flash message shows users name' do
      post :create, params: {user: FactoryBot.attributes_for(:user, first_name: 'Bob', last_name: 'Rob')}
      expect(flash[:notice]).to eq('Bob Rob added!')
    end

    it 'uses user_params' do
      expect(controller).to receive(:user_params)
      post :create, params: {user: FactoryBot.attributes_for(:user)}
    end
  end

  #----------------------------------------------------------------------------
  describe '#edit' do
    before do
      @user = FactoryBot.create(:user, account: @account)
    end

    it 'loads user through set_user' do
      expect(controller).to receive(:set_user).and_call_original
      get :edit, params: {id: @user.id}
    end
  end

  #----------------------------------------------------------------------------
  describe '#update' do
    before(:each) do
      @user = FactoryBot.create(:user, account: @account)
    end

    it 'should update user record' do
      patch :update, params: {id: @user.id, user: {first_name: 'New name'}}
      @user.reload

      expect(@user.first_name).to eq('New name')
      expect(response).to redirect_to(user_path(@user))
    end

    it 'loads user through set_user' do
      expect(controller).to receive(:set_user).and_call_original
      expect(User).to_not receive(:find)
      patch :update, params: {id: @user.id, user: {first_name: 'New name'}}
    end

    it 'flash message should show users name' do
      patch :update, params: {id: @user.id, user: {first_name: 'Jack', last_name: 'Pot'}}
      expect(flash[:notice]).to eq('Jack Pot updated!')
    end
  end

  #----------------------------------------------------------------------------
  describe '#bulk_update' do
    before do
      @user1 = FactoryBot.create(:user, account: @account)
      @user2 = FactoryBot.create(:user, account: @account)
      @user3 = FactoryBot.create(:user, account: @account)

      @role1 = FactoryBot.create(:role, account: @account)
      @role2 = FactoryBot.create(:role, account: @account)
      @role3 = FactoryBot.create(:role, account: @account)

      @user1.update_attribute(:role_ids, [@role1.id, @role2.id])
      @user3.update_attribute(:role_ids, [@role3.id])

      @account2 = FactoryBot.create(:account)
      @user_of_other_account = FactoryBot.create(:user, account: @account2)
      set_http_referer(users_path(q_status_eq: 1))
    end

    it 'updates selected users' do
      patch :bulk_update, params: {user_ids: [@user1.id, @user3.id], user: {role_ids: [@role2.id]}}

      expect(@user1.reload.role_ids).to eq([@role2.id])
      expect(@user2.reload.role_ids).to eq([])
      expect(@user3.reload.role_ids).to eq([@role2.id])
      expect(flash[:notice]).to eq('Users have been updated.')
    end

    it 'ignores blank attributes' do
      patch :bulk_update, params: {user_ids: [@user1.id, @user2.id], user: {role_ids: []}}

      expect(@user1.reload.role_ids).to contain_exactly(@role1.id, @role2.id)
      expect(@user2.reload.role_ids).to eq([])
    end

    it 'redirects back to the referer' do
      patch :bulk_update, params: {user_ids: [@user1.id, @user2.id], user: {role_ids: [@role2.id]}}
      expect(response).to redirect_to(users_path(q_status_eq: 1))
    end

    it 'does not throw ActiveRecord::RecordInvalid when record is invalid' do
      expect {
        patch :bulk_update, params: {user_ids: [@user1.id, @user2.id], user: {role_ids: []}}
      }.not_to raise_error

      expect(flash[:alert]).to be_present
    end

    it 'only allows ids of current_account' do
      expect {
        patch :bulk_update, params: {user_ids: [@user3.id, @user2.id, @user_of_other_account.id], user: {role_ids: [@role2.id]}}
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect(@user3.reload.role_ids).to eq([@role3.id])
      expect(@user2.reload.role_ids).to eq([])
      expect(@user_of_other_account.reload.role_ids).to eq([])
    end

    it 'should use user_params' do
      expect(controller).to receive(:user_params).and_call_original
      patch :bulk_update, params: {user_ids: [@user1.id, @user3.id], user: {role_ids: @role2.id}}
    end
  end

  #----------------------------------------------------------------------------
  describe '#destroy' do
    before(:each) do
      @user = FactoryBot.create(:user, account: @account)
      set_http_referer(users_path(q_role_id_eq: 2))
    end

    it 'should destroy the user' do
      expect {
        delete :destroy, params: {id: @user.id}
      }.to change { User.count }.by(-1)
    end

    it 'flash message should show users name' do
      delete :destroy, params: {id: @user.id}
      expect(flash[:notice]).to eq("#{@user.name} deleted!")
    end

    it 'should redirect back to the referer' do
      delete :destroy, params: {id: @user.id}
      expect(response).to redirect_to(users_path(q_role_id_eq: 2))
    end

    it 'loads user through set_user' do
      expect(controller).to receive(:set_user).and_call_original
      expect(User).to_not receive(:find)
      delete :destroy, params: {id: @user.id}
    end
  end

  #----------------------------------------------------------------------------
  describe '#request_password_reset' do
    it 'queues email notifier' do
      expect(EmailNotifierJob).to receive(:perform_later).with(@user, EmailNotification.templates[:user_password_reset]).and_call_original
      patch :request_password_reset, params: {id: @user.id}

      expect(flash[:notice]).to be_present
    end
  end

  #----------------------------------------------------------------------------
  describe '#set_user' do
    before do
      @user = FactoryBot.create(:user, account: @account)
      allow(controller).to receive(:params).and_return({id: @user.id})
    end

    it 'scopes the query to current account' do
      expect(controller.send(:current_account)).to receive(:users).and_call_original
      controller.send(:set_user)
    end

    it 'sets user ivar' do
      controller.send(:set_user)
      expect(assigns(:user)).to_not be_nil
    end
  end

  #----------------------------------------------------------------------------
  describe '#user_params' do
    it 'should permit UserPolicy permitted_attributes' do
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new({user: {email: 'test@example.com'}}))
      expect_any_instance_of(ActionController::Parameters).to receive(:permit).once
      expect_any_instance_of(UserPolicy).to receive(:permitted_attributes).once
      controller.send(:user_params)
    end
  end

  #----------------------------------------------------------------------------
  describe '#check_user_limit' do
    it "should prevent creating users when the user limit has been reached" do
      expect_any_instance_of(Account).to receive(:reached_user_limit?).and_return(true)

      expect {
        post :create, params: {user: FactoryBot.attributes_for(:user)}
      }.not_to change(User, :count)
      expect(response).to redirect_to(new_user_url)
    end
  end

  #----------------------------------------------------------------------------
  describe 'after_action #verify_authorized' do
    it 'should be called' do
      expect(controller).to receive(:verify_authorized)
      get :index
    end
  end
end
