# == Schema Information
#
# Table name: roles_users
#
#  id      :integer          not null, primary key
#  role_id :integer          not null
#  user_id :integer          not null
#

require 'spec_helper'

describe RolesUser do
  before do
    create_account
    @role1 = FactoryBot.create(:role, account: @account)
    @role2 = FactoryBot.create(:role, account: @account)
  end

  describe 'validations' do
    it 'allows user and role from same account' do
      association = FactoryBot.build(:roles_user, user: @admin, role: @role1)
      expect(association).to be_valid
    end

    it 'does not allow user and role from different accounts' do
      other_user = FactoryBot.create(:user)

      association = FactoryBot.build(:roles_user, user: other_user, role: @role1)
      expect(association).to_not be_valid
      expect(association.errors[:role_id]).to be_present
    end

    describe 'creating through user.role_ids' do
      it 'works fine when all the roles belong to users own account' do
        user = FactoryBot.build(:user, account: @account)
        user.role_ids = [@role1.id, @role2.id]
        expect(user).to be_valid
      end

      it 'adds an error if all the roles do not belong to users own account' do
        other_account = FactoryBot.create(:account)
        other_role    = FactoryBot.create(:role, account: other_account)

        user = FactoryBot.build(:user, account: @account)
        user.role_ids = [@role1.id, @role2.id, other_role.id]
        expect(user).to_not be_valid
        expect(user.errors[:roles_users]).to include('is invalid')
      end
    end
  end

  #----------------------------------------------------------------------------
  # describe 'event log change entry' do
  #   it 'logs change events' do
  #     expect {
  #       @admin.roles << @role1
  #     }.to change { EventLog.count }.by(1)
  #   end
  #
  #   it 'nests new association attributes in the json root as roles_user' do
  #     @admin.roles << @role1
  #
  #     log = EventLog.last
  #     expect(log.data['roles_user']).to be_present
  #   end
  #
  #   it 'sets the event log object to User' do
  #     @admin.roles << @role1
  #
  #     log = EventLog.last
  #     expect(log.object_id).to eq(@admin.id)
  #     expect(log.object_type).to eq('User')
  #   end
  # end
end
