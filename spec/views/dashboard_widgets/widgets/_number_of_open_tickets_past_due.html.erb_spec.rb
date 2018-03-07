require 'spec_helper'

describe '/dashboard_widgets/widgets/_number_of_open_tickets_past_due.html.erb' do
  helper(TicketsUrlHelper)
  helper(DashboardWidgetsHelper)

  before do
    @account = FactoryBot.create(:account)
    @call_center1 = @account.call_centers.first
    @call_center2 = FactoryBot.create(:call_center, account: @account, settings: {})

    @user = account_admin(@account)
    @user.call_centers << @call_center1
    sign_in @user

    allow(view).to receive(:current_account).and_return(@account)
    allow(view).to receive(:current_user).and_return(@user)
  end

  describe 'color of the icons' do
    it 'should be navy when the number of past due tickets is 0' do
      @data = {number_of_tickets: 0}
      render partial: 'dashboard_widgets/widgets/number_of_open_tickets_past_due'
      expect(rendered).to include('icon-primary')
      expect(rendered).to_not include('icon-danger')
    end

    it 'should be danger when the number of past due tickets is over 0' do
      @data = {number_of_tickets: 1}
      render partial: 'dashboard_widgets/widgets/number_of_open_tickets_past_due'
      expect(rendered).to_not include('icon-primary')
      expect(rendered).to include('icon-danger')
    end
  end

end
