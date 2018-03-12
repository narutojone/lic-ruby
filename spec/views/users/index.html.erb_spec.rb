require 'spec_helper'

describe '/users/index.html.erb' do
  # helper(RolesHelper)
  # helper(ConfirmableActionHelper)

  before do
    @account = FactoryBot.create(:account)
    @user = FactoryBot.create(:user, account: @account)
    @policy = Helpers::View::PolicyMock.new

    assign(:user, @user)
    assign(:users, @account.users.page(nil))
    assign(:q, @account.users.ransack({}))
    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:policy).and_return(@policy)
  end

  #----------------------------------------------------------------------------
  describe 'map view button visibility' do
    it 'should not show map view button when user has no show_location permission' do
      render

      expect(rendered).not_to have_css('.map-view-button')
    end

    it 'should show map view button when user has show_location permission' do
      @policy.allow :show_location?
      render

      expect(rendered).to have_css('.map-view-button')
    end
  end

  #----------------------------------------------------------------------------
  describe 'new user button visibility' do
    it 'should not show new user button when user has no create permission' do
      render
      expect(rendered).not_to have_css("a[href='#{new_user_path}']")
    end

    it 'should show new user button when user has a create permission' do
      @policy.allow :new?, :create?
      render
      expect(rendered).to have_css("a[href='#{new_user_path}']")
    end
  end

  #----------------------------------------------------------------------------
  describe 'edit button visibility' do
    it 'should not show edit buttons when user has no edit permission' do
      render
      expect(rendered).not_to have_css("a[href='#{edit_user_path(@user)}']")
    end

    it 'should show edit buttons when user has edit permission' do
      @policy.allow :edit?, :update?
      render
      expect(rendered).to have_css("a[href='#{edit_user_path(@user)}']")
    end
  end

  #----------------------------------------------------------------------------
  describe 'delete button visibility' do
    it 'should not show delete buttons when user has no destroy permission' do
      render
      expect(rendered).not_to have_css("a.js-btn-delete")
    end

    it 'should show delete buttons when user has destroy permission' do
      @policy.allow :edit?, :update?, :destroy?
      render
      expect(rendered).to have_css("a.js-btn-delete")
    end
  end

  #----------------------------------------------------------------------------
  describe 'result count' do
    it 'should display the number of results' do
      render
      expect(rendered).to have_css('span', text: '2 results')
    end

    it 'should display the total number of results not just on this page' do
      assign(:users, @account.users.paginate(page: nil, per_page: 1))
      render
      expect(rendered).to have_css('span', text: '2 results')
    end
  end

  #----------------------------------------------------------------------------
  describe 'call center info and inputs' do
    it 'shows call center select on simple search form' do
      render
      expect(rendered).to have_css('select[name="q[call_centers_users_call_center_id_eq]"]')
    end

    it 'shows call center as a table column' do
      render
      expect(rendered).to have_css('th', text: 'Call Center')
    end
  end
end
