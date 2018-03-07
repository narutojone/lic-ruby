require 'spec_helper'

describe 'layouts/_navigation' do
  helper(SettingsHelper)

  before do
    @account = FactoryGirl.create(:account)
    @user = FactoryGirl.create(:user, account: @account)
    @policy = Helpers::View::PolicyMock.new

    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:current_user).and_return(@user)
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(view).to receive(:policy).and_return(@policy)
  end

  #--------------------------------------------------------------------------
  describe 'Tickets link' do
    it 'should not show the link when the user has no ticket:index permission' do
      render
      expect(rendered).not_to have_css(".sidebar-elements a[href='#{tickets_path}']")
    end

    it 'should show the link when user role has ticket:index permission' do
      @policy.allow :index?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{tickets_path}']")
    end
  end

  #--------------------------------------------------------------------------
  describe 'Excavator Tickets link' do
    it 'does not show the link when the user has no permission' do
      render
      expect(rendered).not_to have_css(".sidebar-elements a[href='#{excavator_tickets_path}']")
    end

    it 'shows the link when user role has permission' do
      @policy.allow :index?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{excavator_tickets_path}']")
    end
  end

  #--------------------------------------------------------------------------
  describe 'Users link' do
    it 'should not show the link when the user has no user:index permission' do
      render
      expect(rendered).not_to have_css(".sidebar-elements a[href='#{users_path}']")
    end

    it 'should show the link when the user role has user:index permission' do
      @policy.allow :index?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{users_path}']")
    end
  end

  #--------------------------------------------------------------------------
  describe 'Audits link' do
    it 'should not show the link when the user has no audit:access permission' do
      render
      expect(rendered).not_to have_css(".sidebar-elements a[href='#{audits_path}']")
    end

    it 'should show the link when the user role has audit:access permission' do
      @policy.allow :access?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{audits_path}']")
    end
  end

  #--------------------------------------------------------------------------
  describe 'Broadcasts link' do
    it 'should not show the link when the user has no broadcast:access permission' do
      render
      expect(rendered).not_to have_css(".sidebar-elements a[href='#{broadcasts_path}']")
    end

    it 'should show the link when the user role has broadcast:access permission' do
      @policy.allow :access?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{broadcasts_path}']")
    end
  end

  #--------------------------------------------------------------------------
  describe 'Reports link' do
    it 'does not show the link when the user has no ticket:see_reports or excavator ticket permission' do
      render
      expect(rendered).not_to have_css(".sidebar-elements a[href='#{reports_path}']")
    end

    it 'shows the link when the user has ticket:see_reports permission' do
      @policy.allow :see_reports?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{reports_path}']")
    end

    it 'shows the link when the user has excavator ticket permission' do
      @policy.allow :index?
      render
      expect(rendered).to have_css(".sidebar-elements a[href='#{reports_path}']")
    end
  end
end
