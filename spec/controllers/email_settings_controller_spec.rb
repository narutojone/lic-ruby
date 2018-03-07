# == Schema Information
#
# Table name: accounts
#
#  id                        :integer          not null, primary key
#  name                      :string
#  full_domain               :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  logo_file_name            :string
#  logo_content_type         :string
#  logo_file_size            :integer
#  logo_updated_at           :datetime
#  one_call_response_enabled :boolean          default(FALSE), not null
#  time_zone                 :string           default("Eastern Time (US & Canada)"), not null
#  one_call_center_id        :integer          default(1), not null
#  raw_one_call_settings     :jsonb
#  email_header              :text             default("<p>{{boss811.logo}}</p>"), not null
#  email_footer              :text             default("<p>Sincerely,</p>\n<p> BOSS811 Team</p>"), not null
#

require 'spec_helper'

RSpec.describe EmailSettingsController do
  render_views

  before do
    create_account_and_login
  end

  #----------------------------------------------------------------------------
  describe '#edit' do
    it 'renders page and returns 200:success' do
      get :edit
      expect(response).to have_http_status(:success)
      expect(response.body).to match(/Header and Footer/)
    end
  end

  #----------------------------------------------------------------------------
  describe '#update' do
    it 'updates account and redirects to edit page' do
      patch :update, params: {account: {email_header: 'Hello, kitty!', email_footer: 'BOSS811, Team'}}
      @account.reload

      expect(@account.email_header).to eq('Hello, kitty!')
      expect(@account.email_footer).to eq('BOSS811, Team')
      expect(flash[:notice]).to be_present
    end

    it 'renders edit page when something goes wrong' do
      allow_any_instance_of(Account).to receive(:valid?).and_return(false)

      patch :update, params: {account: {email_header: 'Hello, kitty!', email_footer: 'BOSS811, Team'}}
      @account.reload

      expect(@account.email_header).not_to eq('Hello, kitty!')
      expect(@account.email_footer).not_to eq('BOSS811, Team')
      expect(response).to render_template :edit
    end
  end

  #----------------------------------------------------------------------------
  describe 'settings_params' do
    it 'should allow only selected parameters' do
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new({account: {email_header: 'Email header', email_footer: 'Email footer'}}))
      expect_any_instance_of(ActionController::Parameters).to receive(:permit).with(:email_header, :email_footer).once
      controller.send(:settings_params)
    end
  end

  #----------------------------------------------------------------------------
  describe 'after_action verify_authorized' do
    it 'should be called' do
      expect(controller).to receive(:verify_authorized)
      get :edit
    end
  end
end
