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

describe User do
  before do
    create_account
    @admin = account_admin(@account)
  end

  #----------------------------------------------------------------------------
  describe 'eventlogging' do
    before do
      @user = FactoryBot.build(:user, account: @account)
    end

    it 'logs its changes' do
      expect { @user.save! }.to change { EventLog.count }.by(1)
      expect { @user.update!(first_name: 'Zlorg') }.to change { EventLog.count }.by(1)
    end

    it 'sets the user as the changed object' do
      expect {
        @user.save!
      }.to change { @user.event_logs.count }.by(1)
    end

    it 'records roles_user removal in event log when a role is removed from the user' do
      @user.save!
      @role = FactoryBot.create(:role, account: @account)
      @user.roles << @role

      expect {
        @user.role_ids = ['']
      }.to change { EventLog.count }.by(1)
    end
  end

  #----------------------------------------------------------------------------
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it 'password should be at least 8 characters' do
      user = FactoryBot.build(:user, account: @account, password: '1234567', password_confirmation: '1234567')
      expect(user.valid?).to eq(false)
      expect(user.errors.messages[:password]).not_to be_nil
      expect(user.errors.messages[:password]).to eq(['is too short (minimum is 8 characters)'])
    end

    it 'must have an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid

      user.email = ''
      expect(user).not_to be_valid

      user.email = 'an@email.com'
      expect(user).to be_valid
    end

    it 'must have time zone set' do
      user = FactoryBot.create(:user)

      user.time_zone = ''
      expect(user).not_to be_valid
    end

    it 'must have a unique email per account' do
      FactoryBot.create(:user, account: @account, email: 'email@example.com')
      user = FactoryBot.build(:user, account: @account, email: 'email@example.com')

      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')

      other_account = FactoryBot.create(:account)
      user = FactoryBot.build(:user, account: other_account, email: 'email@example.com')
      expect(user).to be_valid
    end

    describe 'check_account_admin_count' do
      before do
        @admin = account_admin(@account)
        @admin_role = @account.roles.find_by(admin: true)
      end

      it 'must always have at least one admin in an account' do
        expect(@admin.update(role_ids: [])).to eq(false)
        expect(@admin.errors[:roles]).to include("can't remove the 'Admin' role - an account must have at least one admin")
      end

      it 'should let remove the admin role when there are other admins present' do
        second_admin = FactoryBot.create(:user, account: @account)
        second_admin.roles << @admin_role

        @admin.update(role_ids: [])
        expect(@admin).to be_valid
      end

      it 'should not be run when the record is new' do
        user = FactoryBot.build(:user, account: @account)
        expect(user).to_not receive(:check_account_admin_count)
        user.valid?
      end
    end

    describe 'check_user_limit' do
      before do
        # 3 users total, with the limit as 3
        2.times { FactoryBot.create(:user, account: @account) }
      end

      it 'should check if active flag changed to true' do
        # 4 users total, over the limit
        FactoryBot.create(:user, account: @account)
        user = @account.users.order(:id).last
        user.first_name = 'New name'
        expect(user).to be_valid
      end

      it 'should not add an error when user limit is not exceeded' do
        user = @account.users.order(:id).last
        user.update!(active: false)
        user.active = true
        expect(user).to be_valid
      end

      it 'should add an error when user limit is exceeded' do
        # 4 users total, 1 inactive, not over the limit
        FactoryBot.create(:user, account: @account, active: false)
        user = @account.users.order(:id).last
        user.active = true
        expect(user).to_not be_valid
        expect(user.errors[:base]).to eq(['Cannot activate user since it would exceed the account user limit'])
      end
    end

    describe 'active flag' do
      it 'should not allow nil' do
        user = FactoryBot.build(:user, account: @account)
        user.active = nil
        expect(user).to_not be_valid
        expect(user.errors[:active]).to eq(['is not included in the list'])
      end
    end

    describe 'tickets' do
      it 'should not allow the deletion of user when the user is an assignee of a ticket' do
        user = FactoryBot.create(:user, account: @account)
        ticket = FactoryBot.create(:ticket, account: @account, assignee: user)
        expect(user.destroy).to eq(false)
        expect(user.errors[:base]).to include('Cannot delete record because dependent tickets exist')
      end
    end

    describe '#check_users_associations' do
      let(:user) { FactoryBot.create(:user, account: @account) }

      it 'should not allow the deletion of user when the user is a notificable user of an email notification' do
        FactoryBot.create(:email_notification, account: @account, notifiable_user: user)
        expect(user.destroy).to eq(false)
        expect(user.errors[:base]).to include('Cannot delete the user because the user is a notifiable user of an email notification')
      end

      it 'should not allow the deletion of user when the user is a creator of a note' do
        ticket = FactoryBot.create(:ticket, account: @account)

        Thread.current[:current_user] = user
        FactoryBot.create(:note, ticket: ticket)
        EventLog.delete_all

        expect(user.destroy).to eq(false)
        expect(user.errors[:base]).to include('Cannot delete the user because the user has already created ticket notes')
      end

      it 'should not allow the deletion of user when the user has created ticket responses' do
        ticket = FactoryBot.create(:ticket, account: @account)
        response = FactoryBot.create(:ticket_response, ticket: ticket)
        response.update!(respondent: user)
        expect(user.destroy).to eq(false)
        expect(user.errors[:base]).to include('Cannot delete the user because the user has already created ticket responses')
      end

      it 'should allow user deletion when the user is not tied to anything' do
        expect(user.destroy).to be_truthy
      end
    end
  end

  #----------------------------------------------------------------------------
  describe 'deletion' do
    let(:user) { FactoryBot.create(:user, account: @account) }

    it 'nullifies feedback user ids on deletion' do
      @feedback = FactoryBot.create(:feedback, user: user)
      user.destroy

      expect(@feedback.reload.user_id).to be_nil
    end

    it 'nullifies event log user ids on delete' do
      log = FactoryBot.create(:event_log, account: @account, user: user)
      user.destroy

      expect(log.reload.user_id).to be_nil
    end
  end

  #----------------------------------------------------------------------------
  describe '#generate_api_key' do
    it 'should generate an api key' do
      user = FactoryBot.create(:user, account: @account, api_key: nil)

      user.generate_api_key
      user.reload
      expect(user.api_key).to_not be_nil
      expect(user.api_key.length).to eq(50)
    end

    it 'should overwrite the existing api key' do
      user = FactoryBot.create(:user, account: @account, api_key: 'current api key')

      user.generate_api_key
      user.reload
      expect(user.api_key).not_to eq('current api key')
    end

    it 'should generate a unique api key' do
      FactoryBot.create(:user, account: @account, api_key: 'key')
      allow(SecureRandom).to receive(:hex).and_return('key', 'key', 'another key', 'key')

      user = FactoryBot.create(:user, api_key: nil)
      user.generate_api_key
      user.reload
      expect(user.api_key).to eq('another key')
    end

    it 'shouldnt leave a event log entry' do
      user = FactoryBot.create(:user)
      expect {
        user.generate_api_key
      }.not_to change { EventLog.count }
    end
  end

  #----------------------------------------------------------------------------
  describe '#permission_marks' do
    before do
      @role1 = FactoryBot.create(:role, account: @account, permissions: [1, 2])
      @role2 = FactoryBot.create(:role, account: @account, permissions: [2, 3])
      @user = FactoryBot.create(:user, account: @account)

      @user.roles << @role1
      @user.roles << @role2
      @admin.roles << @role1
    end

    it 'returns list of all permissions for admin' do
      expect(@admin.permission_marks).to be_kind_of(Array)
      expect(@admin.permission_marks.length).to eq(PERMISSIONS.map{ |k, v| v[:activities].values }.flatten.length)
      expect(@admin.permission_marks[0]).to eq({group: 'role', activity: 'index'})
    end

    it 'returns list of permissions for regular user' do
      expect(@user.permission_marks.sort { |x, y| x[:activity] <=> y[:activity] }).to eq([{group: 'role', activity: 'create'}, {group: 'role', activity: 'index'}, {group: 'role', activity: 'update'}])
    end
  end

  #----------------------------------------------------------------------------
  describe '#has_permission?' do
    before do
      @role1 = FactoryBot.create(:role, account: @account, permissions: [1])
      @role2 = FactoryBot.create(:role, account: @account, permissions: [2])
    end

    it 'checks for permission from each of users roles' do
      user = FactoryBot.create(:user, account: @account)
      user.roles << @role1
      expect(user.has_permission?('role', 'index')).to eq(true)
      expect(user.has_permission?('role', 'create')).to eq(false)
      expect(user.has_permission?('role', 'update')).to eq(false)

      user.roles << @role2
      expect(user.has_permission?('role', 'index')).to eq(true)
      expect(user.has_permission?('role', 'create')).to eq(true)
      expect(user.has_permission?('role', 'update')).to eq(false)
    end

    it 'always returns true for admins' do
      admin = account_admin(@account)
      PERMISSIONS.each_pair do |resource, attrs|
        attrs[:activities].each_key do |activity|
          expect(admin.has_permission?(resource, activity)).to eq(true)
        end
      end
    end

    it 'always returns false for a non-admin without a role' do
      user = FactoryBot.create(:user, account: @account)
      PERMISSIONS.each_pair do |resource, attrs|
        attrs[:activities].each_key do |activity|
          expect(user.has_permission?(resource, activity)).to eq(false)
        end
      end
    end
  end

  #----------------------------------------------------------------------------
  describe '#name, #to_s' do
    it 'should return users full name' do
      user = FactoryBot.build(:user, account: @account, first_name: 'Leopold', last_name: 'Xavier')
      expect(user.to_s).to eq('Leopold Xavier')
    end

    it 'should return only first name if last name is blank' do
      user = FactoryBot.build(:user, account: @account, first_name: 'Leopold', last_name: nil)
      expect(user.to_s).to eq('Leopold')
    end
  end

  #----------------------------------------------------------------------------
  describe '#password_required?' do
    it 'requires password when it is present' do
      @admin.password = '123123123'
      @admin.password_confirmation = nil

      expect(@admin.send(:password_required?)).to eq(true)
    end

    it 'requires password when password conformation is present' do
      @admin.password = nil
      @admin.password_confirmation = '123123123'

      expect(@admin.send(:password_required?)).to eq(true)
    end

    it 'requires password when the user is created as the first user along with the account' do
      plan = FactoryBot.create(:advanced_subscription_plan)
      account = Account.create(
        domain: 'mynewaccount',
        users_attributes: {
          '0': {
            first_name: 'Account',
            last_name: 'Owner',
            email: 'account.owner@example.com',
            password: '',
            password_confirmation: ''
          }
        },
        plan: plan
      )

      expect(account.errors['users.password']).to include("can't be blank")
    end

    it 'doesnt require password when changing non-password fields' do
      @admin.first_name = 'Theodor'
      expect(@admin.send(:password_required?)).to eq(false)
    end

    it 'doesnt require password when creating a new user to an existing account' do
      user = FactoryBot.build(:user, account: @account, password: '', password_confirmation: '')
      expect(user.send(:password_required?)).to eq(false)
    end
  end

  describe '#tickets' do
    it 'should be possible to delete user without assigned tickets' do
      user = FactoryBot.create(:user, account: @account)
      expect{ user.destroy }.to change{ User.count }.by(-1)
    end

    it 'shouldnt be possible to delete user with tickets' do
      user   = FactoryBot.create(:user, account: @account)
      ticket = FactoryBot.create(:ticket, account: @account, assignee: user)

      expect{ user.destroy }.not_to change{ User.count }
      expect(user.errors.messages[:base]).not_to be_nil
    end
  end

  describe '#time_entries' do
    it 'should be possible to delete user without assigned time entries' do
      user = FactoryBot.create(:user, account: @account)
      expect{ user.destroy }.to change{ User.count }.by(-1)
    end

    it 'shouldnt be possible to delete user with time entries' do
      user = FactoryBot.create(:user, account: @account)
      ticket = FactoryBot.create(:ticket, account: @account)
      time_entry = FactoryBot.create(:time_entry, user: user, ticket: ticket)

      expect{ user.destroy }.not_to change{ User.count }
      expect(user.errors.messages[:base]).not_to be_nil
    end
  end

  #----------------------------------------------------------------------------
  describe 'scopes' do
    describe 'is_active' do
      before do
        @active_user = FactoryBot.create(:user, account: @account, active: true)
        @inactive_user = FactoryBot.create(:user, account: @account, active: false)
      end

      it 'loads active users by default' do
        expect(@account.users.is_active).to include(@active_user)
        expect(@account.users.is_active).to_not include(@inactive_user)
      end

      it 'loads active users when passed true' do
        expect(@account.users.is_active(true)).to include(@active_user)
        expect(@account.users.is_active(true)).to_not include(@inactive_user)
      end

      it 'loads inactive users when passed false' do
        expect(@account.users.is_active(false)).to_not include(@active_user)
        expect(@account.users.is_active(false)).to include(@inactive_user)
      end
    end

    describe '.order_by_name' do
      before do
        @benjamin = FactoryBot.create :user, account: @account,
                                       first_name: 'Benjamin', last_name: 'Waldron'
        @adam = FactoryBot.create :user, account: @account,
                                   first_name: 'Adam', last_name: 'Waldron'
        @christie = FactoryBot.create :user, account: @account,
                                       first_name: 'Christie', last_name: 'Salas'
      end

      it 'orders users by last and first name' do
        expect(User.order_by_name.where('id != ?', @admin)).to eq([@christie, @adam, @benjamin])
      end
    end

    describe '.possible_assignees' do
      it 'returns something' do
        expect(User.possible_assignees.length).to eq(1)
        assignee = User.possible_assignees.first

        expect(assignee.id).to be_present
        expect(assignee.name).to eq('Account Admin')
      end
    end
  end

  #----------------------------------------------------------------------------
  describe '#set_initial_time_zone' do
    it 'should set users time zone to that of its accounts' do
      account = FactoryBot.create(:account, time_zone: 'Bangkok')
      new_user = FactoryBot.create(:user, account: account, time_zone: nil)
      expect(new_user.reload.time_zone).to eq('Bangkok')
    end

    it 'should not override the time zone when it is already set' do
      account = FactoryBot.create(:account, time_zone: 'Bangkok')
      new_user = FactoryBot.create(:user, account: account, time_zone: 'Vanuatu')
      expect(new_user.reload.time_zone).to eq('Vanuatu')
    end
  end

  #----------------------------------------------------------------------------
  describe '#admin?' do
    before do
      @user   = FactoryBot.create(:user, account: @account)
      @role1 = FactoryBot.create(:role, account: @account, name: 'Admin 1', admin: true)
      @role2 = FactoryBot.create(:role, account: @account)
    end

    it 'always returns true for admins' do
      @user.roles << @role2
      @user.roles << @role1
      expect(@user.admin?).to eq(true)
    end

    it 'always returns false for a non-admin' do
      @user.roles << @role2
      expect(@user.admin?).to eq(false)
    end
  end
end
