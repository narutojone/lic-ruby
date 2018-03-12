require 'spec_helper'

describe '/users/edit.html.erb' do
  before do
    @account = FactoryBot.create(:account)
    @admin = account_admin(@account)
    @role = FactoryBot.create(:role, account: @account)
    @policy = Helpers::View::PolicyMock.new

    assign(:user, @admin)
    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:policy).and_return(@policy)
  end

  describe 'roles select' do
    context 'user does not have user:update permission' do
      it 'should not show role select' do
        @policy.allow :index?
        allow_any_instance_of(Account).to receive(:reached_user_limit?).and_return(true)
        render
        expect(rendered).not_to have_css('input[name="user[role_ids][]"]')
      end
    end

    context 'user has user:update permission' do
      before do
        @policy.allow :index?
        @policy.permitted_attributes = [role_ids: []]
      end

      it 'should show role select' do
        render
        expect(rendered).to have_css('select[name="user[role_ids][]"]')
      end

      it 'should show an error message when there is an error with roles' do
        @admin.errors.add(:roles, 'An error with roles')
        render
        expect(rendered).to have_css('span.help-block', text: 'An error with roles')
        expect(rendered).to have_css('div.form-group.has-error')
      end
    end
  end

  describe 'active checkbox' do
    it 'should not show the active checkbox when user does not have the permission to change the flag' do
      @policy.allow :index?
      render
      expect(rendered).not_to have_css('input[name="user[active]"]')
    end

    it 'should show the active checkbox when user does have the permission to change the flag' do
      @policy.allow :index?
      @policy.permitted_attributes = [:active]
      render
      expect(rendered).to have_css('input[name="user[active]"]')
    end
  end

  describe 'cancel link' do
    it 'should redirect to users list if the user has user:list permission' do
      @policy.allow :index?
      render
      expect(rendered).to include('<a href="#" class="btn btn-default js-back-link">Cancel</a>')
    end

    it 'should redirect to dashboard when the user does not have user:list permission' do
      render
      expect(rendered).to include('<a href="#" class="btn btn-default js-back-link">Cancel</a>')
    end
  end

  describe 'password fields' do
    it 'does not show password fields even if user has user:update permission' do
      @policy.allow :edit?
      render
      expect(rendered).to_not have_css('input[name="user[password]"]')
      expect(rendered).to_not have_css('input[name="user[password_confirmation]"]')
    end
  end
end
