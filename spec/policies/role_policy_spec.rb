require 'spec_helper'

describe RolePolicy do

  before(:each) do
    @account = FactoryBot.create(:account)
    @user = FactoryBot.create(:user, account: @account)
    @role = FactoryBot.create(:role, account: @account)
    @admin_role = FactoryBot.create(:role, account: @account, admin: true)
  end

  subject { described_class }

  permissions :index? do
    it 'denies access if users role does not have role:index permission' do
      expect(subject).not_to permit(@user, Role)
    end

    it 'grants access if users role has role:index permission' do
      grant_permission(@user, 1)

      expect(subject).to permit(@user, Role)
    end
  end

  permissions :new? do
    it 'calls create?' do
      expect_any_instance_of(subject).to receive(:create?)
      subject.new(@user, Role).new?
    end
  end

  permissions :create? do
    it 'denies access if users role does not have role:create permission' do
      expect(subject).not_to permit(@user, Role)
    end

    it 'grants access if users role has role:create permission' do
      grant_permission(@user, 2)

      expect(subject).to permit(@user, Role)
    end
  end

  permissions :edit? do
    it 'calls update?' do
      expect_any_instance_of(subject).to receive(:update?)
      subject.new(@user, @admin_role).edit?
    end
  end

  permissions :update? do
    it 'denies access if users role does not have role:update permission' do
      expect(subject).not_to permit(@user, @role)
    end

    it 'grants access if users role has role:update permission' do
      grant_permission(@user, 3)

      expect(subject).to permit(@user, @role)
    end

    it 'denies access if the role is an admin role' do
      grant_permission(@user, 3)
      expect(subject).not_to permit(@user, @admin_role)
    end
  end

  permissions :update_all? do
    it 'denies access if users role does not have role:update permission' do
      expect(subject).not_to permit(@user, Role)
    end

    it 'grants access if users role has role:update permission' do
      grant_permission(@user, 3)

      expect(subject).to permit(@user, Role)
    end
  end

  permissions :destroy? do
    it 'denies access if users role does not have role:destroy permission' do
      expect(subject).not_to permit(@user, @role)
    end

    it 'grants access if users role has role:destroy permission' do
      grant_permission(@user, 4)

      expect(subject).to permit(@user, @role)
    end

    it 'denies access if the role is an admin role' do
      grant_permission(@user, 4)
      expect(subject).not_to permit(@user, @admin_role)
    end
  end
end
