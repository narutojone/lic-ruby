require 'spec_helper'

describe '/users/new.html.erb' do
  before do
    @account = FactoryBot.create(:account)
    @policy = Helpers::View::PolicyMock.new(:index?)

    assign(:user, User.new)
    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:policy).and_return(@policy)
  end

  describe "when the user limit has been reached" do
    before do
      @account.subscription.update_attribute(:user_limit, @account.users.count)
      allow_any_instance_of(Account).to receive(:reached_user_limit?).and_return(true)
      render
    end

    it "should show text explaining the limit" do
      expect(rendered).to match(/You have reached the maximum number of users you can have with your account level./)
    end

    it "should not show the form" do
      expect(rendered).not_to have_css('form')
    end
  end

  describe "when the limit has not been reached" do
    it "should show the form" do
      render
      expect(rendered).to have_css("form[action='#{users_path}']")
    end

    it "should not show the text explaining the limit" do
      render
      expect(rendered).not_to match(/You have reached the maximum number of open users you can have with your account level./)
    end
  end

  describe 'API key field and generation button' do
    it 'should not show it when creating a new user' do
      assign(:user, User.new)
      render
      expect(rendered).not_to have_css('input[id="user_api_key"]')
      expect(rendered).not_to match(/Generate a new key.../)
    end
  end

  describe 'password fields' do
    it 'does not show password fields' do
      render
      expect(rendered).to_not have_css('input[name="user[password]"]')
      expect(rendered).to_not have_css('input[name="user[password_confirmation]"]')
    end
  end
end
