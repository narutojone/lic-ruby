require 'spec_helper'

RSpec.describe SettingsController do
  render_views

  before(:each) do
    create_account_and_login
  end

  #----------------------------------------------------------------------------
  describe '#index' do
    it 'renders page and returns http success' do
      get :index

      expect(response).to have_http_status(:success)
      expect(response.body).to match(/Settings/)
    end
  end
end
