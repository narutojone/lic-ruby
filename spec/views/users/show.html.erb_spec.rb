require 'spec_helper'

describe '/users/show.html.erb' do
  # helper(TicketsHelper)

  before do
    @account = FactoryBot.create(:account)
    @user = FactoryBot.create(:user, account: @account)
    @policy = Helpers::View::PolicyMock.new

    assign(:user, @user)
    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:policy).and_return(@policy)
  end

  describe 'User edit button' do
    it 'should not show the edit button when the user role has no edit permission' do
      render
      expect(rendered).not_to have_css("a[href='#{edit_user_path(@user)}']")
    end

    it 'should show the edit button when the user role has edit permission' do
      @policy.allow :edit?, :update?
      render
      expect(rendered).to have_css("a[href='#{edit_user_path(@user)}']")
    end
  end
end
