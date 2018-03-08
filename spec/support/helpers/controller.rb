module Helpers
  module Controller
    def create_account_and_login(account_params = {})
      create_account(account_params)
      sign_in(@admin)
    end

    #--------------------------------------------------------------------------
    def create_account_and_api_login(account_params = {})
      create_account(account_params)

      @admin.generate_api_key
      api_login(@admin.api_key)
    end

    #--------------------------------------------------------------------------
    def create_account(account_params = {})
      @account = FactoryBot.create(:account, account_params)
      @admin = account_admin(@account)

      @request.host = "#{@account.domain}.lvh.me"
      allow(@request).to receive(:subdomain).and_return(@account.domain)
      @request.env["devise.mapping"] = Devise.mappings[:user]

      @account
    end

    #--------------------------------------------------------------------------
    def api_login(api_key)
      if api_key.present?
        auth_token = ActionController::HttpAuthentication::Token.encode_credentials(api_key)
      else
        auth_token = ''
      end

      request.env['HTTP_AUTHORIZATION'] = auth_token
    end

    #--------------------------------------------------------------------------
    def json_response
      JSON.parse(response.body)
    end
  end
end
