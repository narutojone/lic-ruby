# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  account_id  :integer          not null
#  name        :string           not null
#  permissions :integer          default([]), not null, is an Array
#  admin       :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

RSpec.describe Role do
  let(:role) { FactoryBot.create(:role) }

  #----------------------------------------------------------------------------
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(role).to be_valid
    end

    it 'is invalid without a name' do
      role.name = ''
      expect(role).not_to be_valid
    end

    describe 'permissions' do
      it 'allows empty array' do
        role.permissions = []
        expect(role).to be_valid
      end

      it 'does not allow nil' do
        role.permissions = nil
        expect(role).to_not be_valid
      end
    end

    describe 'destroy' do
      it 'does not destroy role when a user has this role' do
        user = FactoryBot.create(:user, account: role.account)
        user.roles << role
        expect {
          expect(role.destroy).to eq(false)
        }.to_not change { Role.count }
        expect(role.errors[:base]).to eq(['Can not delete a role when a user with this role exists!'])
      end

      it 'destroys the role when no user has this role' do
        role = FactoryBot.create(:role)
        expect {
          expect(role.destroy).to be_truthy
        }.to change { Role.count }.by(-1)
      end
    end
  end

  #----------------------------------------------------------------------------
  describe '#permission_marks' do
    it 'returns permissions as a list' do
      role.permissions = [4, 5, 9]
      role.save

      expect(role.permission_marks).to eq([{group: 'role', activity: 'destroy'}, {group: 'user', activity: 'index'}, {group: 'user', activity: 'destroy'}])
    end

    it 'returns all permissions for the admin role' do
      role.permissions = []
      role.admin = true
      role.save

      expect(role.permission_marks.length).to eq(PERMISSIONS_BY_ID.length)
    end

    it 'removes nulls from permissions' do
      role.permissions = [4, 5, 9000]
      expect(role.permission_marks).to eq([{group: 'role', activity: 'destroy'}, {group: 'user', activity: 'index'}])
    end
  end

  #----------------------------------------------------------------------------
  describe 'clean_permissions' do
    it 'checks the permission ids and remove ones that are invalid or repeated' do
      role.permissions = [nil, 'asd', 4, 5, -13, '9', nil, 5, 'test', 3823823]
      role.save
      expect(role.permissions).to eq([4, 5, 9])
    end

    it 'does not run when permissions have not changed' do
      expect(role.permissions).to_not receive(:select)
      role.name = 'new name'
      role.save
    end

    it 'does not run when permissions is nil' do
      expect(role.permissions).to_not receive(:select)
      role.permissions = nil
      role.save
    end
  end

end
