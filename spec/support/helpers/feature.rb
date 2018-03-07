module Helpers
  module Feature

    def create_account
      # If this fails for you, make sure that company.boss811.test resolves
      # to localhost 127.0.0.1 in the machine this test is running on
      Capybara.app_host = 'http://company.boss811.test'
      @account = FactoryGirl.create(:account, full_domain: 'company.boss811.test')
      @admin   = account_admin(@account)
    end

    def create_account_and_login
      create_account

      visit root_path

      fill_in 'user_email', with: @admin.email
      fill_in 'user_password', with: '123123123'
      click_button 'Log me in'
    end

  end
end
