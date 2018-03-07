require 'spec_helper'

describe '/roles/new.html.erb' do
  helper(SettingsHelper)

  before(:each) do
    @account = FactoryBot.create(:account)
    @policy = Helpers::View::PolicyMock.new

    assign(:role, Role.new)
    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:policy).and_return(@policy)
  end

  context 'when the role limit has been reached' do
    before(:each) do
      @account.subscription.update_attribute(:role_limit, @account.roles.count)
      render
    end

    it 'should show text explaining the limit' do
      expect(rendered).to match(/You have reached the maximum number of roles you can have with your account level./)
    end

    it 'should not show the form' do
      expect(rendered).not_to have_css('form')
    end
  end

  context 'when the limit has not been reached' do
    before(:each) do
      render
    end

    it 'should show the form' do
      expect(rendered).to have_css("form[action='#{roles_path}']")
    end

    it 'should not show the text explaining the limit' do
      expect(rendered).not_to match(/You have reached the maximum number of roles you can have with your account level./)
    end
  end
end
