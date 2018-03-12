require 'spec_helper'

describe '/roles/index.html.erb' do
  # helper(SettingsHelper)
  # helper(ConfirmableActionHelper)

  before(:each) do
    @account = FactoryBot.create(:account)
    @role = FactoryBot.create(:role, account: @account)
    @user = FactoryBot.create(:user, account: @account)
    @policy = Helpers::View::PolicyMock.new

    assign(:user, @user)
    assign(:roles, @account.roles)
    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:policy).and_return(@policy)
  end

  describe 'new role button visibility' do
    it 'should not show new role button when the user role has no create permission' do
      render
      expect(rendered).not_to have_css("a[href='#{new_role_path}']")
    end

    it 'should show new role button when the user role has a create permission' do
      @policy.allow :new?, :create?
      render
      expect(rendered).to have_css("a[href='#{new_role_path}']")
    end
  end

  describe 'edit button visibility' do
    it 'should not show edit buttons when the user role has no edit permission' do
      render
      expect(rendered).not_to have_css("a[href='#{edit_role_path(@role)}']")
    end

    it 'should show edit buttons when the user role has edit permission' do
      @policy.allow :edit?, :update?, :destroy?
      render
      expect(rendered).to have_css("a[href='#{edit_role_path(@role)}']")
    end
  end

  describe 'delete button visibility' do
    it 'should not show delete buttons when the user role has no destroy permission' do
      render
      expect(rendered).not_to have_css("a.js-btn-delete")
    end

    it 'should show delete buttons when the user role has destroy permission' do
      @policy.allow :edit?, :update?, :destroy?
      render
      expect(rendered).to have_css("a.js-btn-delete")
    end
  end

  describe 'edit all button visibility' do
    it 'should not show the button when the user role has no update_all permission' do
      render
      expect(rendered).not_to have_css("a[href='#{edit_all_roles_path}']")
    end

    it 'should show the button when the user role has update_all permission' do
      @policy.allow :update_all?
      render
      expect(rendered).to have_css("a[href='#{edit_all_roles_path}']")
    end
  end

  describe 'result count' do
    it 'should display the number of results' do
      render
      expect(rendered).to have_css('span', text: '2 results')
    end
  end
end
