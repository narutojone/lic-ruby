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

RSpec.describe RolesController do
  render_views

  before(:each) do
    create_account_and_login
  end

  #----------------------------------------------------------------------------
  describe '#index' do
    it 'should scope the query to current account' do
      current_account = double(:current_account)
      allow(controller).to receive(:current_account).and_return(current_account)
      allow(current_account).to receive(:roles).and_return([])

      expect(current_account).to receive(:roles)
      get :index
    end

    it 'should assign roles ivar' do
      get :index
      expect(assigns(:roles)).to_not be_nil
    end
  end

  #----------------------------------------------------------------------------
  describe '#new' do
    it 'should assign a new role' do
      get :new
      expect(assigns(:role)).to_not be_nil
      expect(assigns(:role).new_record?).to be(true)
    end
  end

  #----------------------------------------------------------------------------
  describe '#create' do
    it 'should create the role under the current account' do
      expect {
        post :create, params: {role: FactoryBot.attributes_for(:role)}
      }.to change{ @account.roles.count }.by(1)
      expect(flash[:notice]).to eq('Role added!')
    end

    it 'should use role_params' do
      expect(controller).to receive(:role_params)
      post :create, params: {role: FactoryBot.attributes_for(:role)}
    end
  end

  #----------------------------------------------------------------------------
  describe '#edit' do
    before(:each) do
      @role = FactoryBot.create(:role, account: @account)
    end

    it 'loads role through set_role' do
      expect(controller).to receive(:set_role).and_call_original
      get :edit, params: {id: @role.id}
    end
  end

  #----------------------------------------------------------------------------
  describe '#update' do
    before(:each) do
      @role = FactoryBot.create(:role, account: @account, permissions: [1])
    end

    it 'should update permissions, set notice and redirect user' do
      patch :update, params: {id: @role.id, role: {name: 'New name', permissions: [2, 3]}}

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to be_present
      expect(@role.reload.permissions).to eq([2, 3])
    end

    it 'should use role_params' do
      expect(controller).to receive(:role_params).and_call_original
      patch :update, params: {id: @role.id, role: {name: 'New name'}}

      expect(flash[:notice]).to eq('Role updated!')
    end

    it 'loads role through set_role' do
      expect(controller).to receive(:set_role).and_call_original
      expect(Role).to_not receive(:find)

      patch :update, params: {id: @role.id, role: {name: 'New name'}}
    end
  end

  #----------------------------------------------------------------------------
  describe '#edit_all' do
    it 'should load all roles except admin role' do
      role1 = FactoryBot.create(:role, account: @account)
      role2 = FactoryBot.create(:role, account: @account)

      get :edit_all
      roles = assigns(:roles)
      expect(roles.length).to eq(2)
      expect(roles).to include(role1, role2)
    end
  end

  #----------------------------------------------------------------------------
  describe '#update_all' do
    before(:each) do
      @role1 = FactoryBot.create(:role, account: @account, permissions: [7, 8])
      @role2 = FactoryBot.create(:role, account: @account, permissions: [2, 6])
    end

    it 'should update all roles, set notice and redirect user' do
      patch :update_all, params: {permissions: {
        @role1.id.to_s => {permissions: [1]},
        @role2.id.to_s => {permissions: [2, 3, 4]}
      }}

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to be_present

      expect(@role1.reload.permissions).to eq([1])
      expect(@role2.reload.permissions).to eq([2, 3, 4])
    end

    it 'shouldnt crash on empty permission list' do
      expect { patch :update_all }.not_to raise_error
    end

    it 'should ignore empty permissions' do
      patch :update_all, params: {permissions: { @role1.id.to_s => nil }}
      expect(@role1.reload.permissions).to eq([7, 8])
    end

    it 'should not try to modify admins role' do
      admin_role = @account.roles.find_by(admin: true)
      patch :update_all, params: {
              permissions: {admin_role.id.to_s => {permissions_attributes: {
                '0' => {type_id: 1},
                '1' => {type_id: 2}
              }}}
            }
      expect(admin_role.reload.permissions).to be_empty
    end

    it 'should not modify roles that are not from this account' do
      other_account = FactoryBot.create(:account)
      other_role = FactoryBot.create(:role, account: other_account)

      patch :update_all, params: {
            permissions: {other_role.id.to_s => {permissions_attributes: {
              '0' => {type_id: 1},
              '1' => {type_id: 2}
            }}}
          }
      expect(other_role.reload.permissions).to be_empty
    end
  end

  #----------------------------------------------------------------------------
  describe '#destroy' do
    before(:each) do
      @role = FactoryBot.create(:role, account: @account)
    end

    it 'should destroy the role' do
      expect {
        delete :destroy, params: {id: @role.id}
      }.to change { Role.count }.by(-1)
      expect(flash[:notice]).to eq('Role deleted!')
    end

    it 'should show an error message when the role can not be destroyed' do
      user = FactoryBot.create(:user, account: @account)
      user.roles << @role

      delete :destroy, params: {id: @role.id}
      expect(flash[:alert]).to_not be_nil
    end

    it 'loads role through set_role' do
      expect(controller).to receive(:set_role).and_call_original
      expect(Role).to_not receive(:find)
      delete :destroy, params: {id: @role.id}
    end
  end

  #----------------------------------------------------------------------------
  describe '#set_role' do
    before(:each) do
      role = FactoryBot.create(:role, account: @account)
      allow(controller).to receive(:params).and_return({:id => role.id})
    end

    it 'should scope the query to current account' do
      controller.send(:set_role)

      expect(assigns(:role)).to be_a(Role)
      expect(assigns(:role).account).to eql(controller.send(:current_account))
    end

    it 'should set role ivar' do
      controller.send(:set_role)
      expect(assigns(:role)).to_not be_nil
    end
  end

  #----------------------------------------------------------------------------
  describe '#role_params' do
    it 'should allow only selected parameters' do
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new({role: {name: 'role name'}}))
      expect_any_instance_of(ActionController::Parameters).to receive(:permit).with(:name, permissions: []).once
      controller.send(:role_params)
    end
  end

  describe 'after_action verify_authorized' do
    it 'should be called' do
      expect(controller).to receive(:verify_authorized)
      get :index
    end
  end
end
