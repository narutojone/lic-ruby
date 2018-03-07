require 'spec_helper'

describe UserPolicy do
  subject { described_class }

  before do
    @account = FactoryGirl.create(:account)
    @user = FactoryGirl.create(:user, account: @account)
    @other_user = FactoryGirl.create(:user, account: @account)
  end

  #----------------------------------------------------------------------------
  permissions :index? do
    it 'denies access if users role does not have user:index permission' do
      expect(subject).not_to permit(@user, User)
    end

    it 'grants access if users role has user:index permission' do
      grant_permission(@user, 5)

      expect(subject).to permit(@user, User)
    end
  end

  #----------------------------------------------------------------------------
  permissions :show? do
    it 'denies access if users role does not have user:show permission' do
      expect(subject).not_to permit(@user, User)
    end

    it 'grants access if users role has user:show permission' do
      grant_permission(@user, 6)

      expect(subject).to permit(@user, User)
    end
  end

  #----------------------------------------------------------------------------
  permissions :show_location? do
    it 'denies access if users role does not have user:show_location permission' do
      grant_permission(@user, -1)
      expect(subject).not_to permit(@user, User)
    end

    it 'grants access if users role has user:show_location permission' do
      grant_permission(@user, 40)
      expect(subject).to permit(@user, User)
    end
  end

  #----------------------------------------------------------------------------
  permissions :new?, :create? do
    it 'denies access if users role does not have user:create permission' do
      expect(subject).not_to permit(@user, User)
    end

    it 'grants access if users role has user:create permission' do
      grant_permission(@user, 7)

      expect(subject).to permit(@user, User)
    end
  end

  #----------------------------------------------------------------------------
  permissions :edit?, :update? do
    before do
      @other_user = FactoryGirl.create(:user, account: @account)
    end

    it 'denies access if users role does not have user:update permission' do
      expect(subject).not_to permit(@user, @other_user)
    end

    it 'grants access if users role has user:update permission' do
      grant_permission(@user, 8)

      expect(subject).to permit(@user, @other_user)
    end

    it 'grants access when user is trying to update itself' do
      expect(subject).to permit(@user, @user)
    end

    it 'also allows usage of User class for querying the permission' do
      # we just test that the User class can be set as parameter and not throw and error
      expect(subject).not_to permit(@user, User)
    end
  end

  #----------------------------------------------------------------------------
  permissions :destroy? do
    before do
      @other_user = FactoryGirl.create(:user, account: @account)
    end

    it 'denies access if users role does not have user:destroy permission' do
      expect(subject).not_to permit(@user, @other_user)
    end

    it 'grants access if users role has user:destroy permission' do
      grant_permission(@user, 9)

      expect(subject).to permit(@user, @other_user)
    end

    it 'denies access when trying to delete yourself' do
      grant_permission(@user, 9)

      expect(subject).not_to permit(@user, @user)
    end
  end

  #----------------------------------------------------------------------------
  describe 'permitted_attributes' do
    it 'permits attributes' do
      expect(UserPolicy.new(@user, User).permitted_attributes).to contain_exactly(:email, :remember_me, :first_name, :last_name, :time_zone)
    end

    it 'permits the change of password only to the user themselves' do
      expect(UserPolicy.new(@user, @user).permitted_attributes).to include(:password, :password_confirmation)
    end

    it 'does not permit the change of password when a class is passed as the user' do
      expect(UserPolicy.new(@user, User).permitted_attributes).to_not include(:password)
      expect(UserPolicy.new(@user, User).permitted_attributes).to_not include(:password_confirmation)
    end

    context 'user does NOT have user:update permission' do
      it 'does not permit the user to change the roles' do
        expect(UserPolicy.new(@user, User).permitted_attributes).not_to include(role_ids: [])
      end

      it 'does not permit the user to change their call centers' do
        expect(UserPolicy.new(@user, User).permitted_attributes).not_to include(call_center_ids: [])
      end

      it 'does not permit the user to change the active flag' do
        expect(UserPolicy.new(@user, User).permitted_attributes).not_to include(:active)
      end

      it 'does not permit the change of password of a different user' do
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to_not include(:password)
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to_not include(:password_confirmation)
      end
    end

    context 'user HAS user:update permission' do
      before do
        grant_permission(@user, 8)
      end

      it 'permits the user to change the roles' do
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to include(role_ids: [])
      end

      it 'permits the user to change the call centers' do
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to include(call_center_ids: [])
      end

      it 'permits the user to change the active flag of others' do
        # new records
        expect(UserPolicy.new(@user, User).permitted_attributes).to include(:active)
        # existing records
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to include(:active)
      end

      it 'does NOT permit the user to change the active flag of yourself' do
        expect(UserPolicy.new(@user, @user).permitted_attributes).to_not include(:active)
      end

      it 'does not permit the change of password of a different user' do
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to_not include(:password)
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to_not include(:password_confirmation)
      end
    end

    context 'user HAS user:create permission' do
      before do
        grant_permission(@user, 7)
      end

      it 'permits the user to assign the roles' do
        expect(UserPolicy.new(@user, User).permitted_attributes).to include(role_ids: [])
      end

      it 'permits the user to assign call centers' do
        expect(UserPolicy.new(@user, User).permitted_attributes).to include(call_center_ids: [])
      end

      it 'permits the user to set the active flag' do
        expect(UserPolicy.new(@user, User).permitted_attributes).to include(:active)
      end

      it 'does not permit the setting of password' do
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to_not include(:password)
        expect(UserPolicy.new(@user, @other_user).permitted_attributes).to_not include(:password_confirmation)
      end
    end
  end
end
