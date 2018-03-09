require 'spec_helper'

class NotAuthorized
end

class NotAuthorizedPolicy < ApplicationPolicy
  def not_authorized?
    false
  end
end

describe ApplicationController do
  #----------------------------------------------------------------------------
  before(:each) do
    create_account_and_login(domain: 'company')

    # FactoryBot.create(:ticket, account: @account)

    Rails.application.routes.draw do
      root to: 'application#show'

      get 'show'   => 'application#show'
      get 'update' => 'application#update'
      get 'not_authorized' => 'application#not_authorized'
      get 'param_missing'  => 'application#param_missing'

      resource :account do
        member do
          match 'billing' => 'accounts#billing', via: [ :get, :post ]
        end
      end
    end

    # Since ApplicationController is just a base controller for all controllers,
    # it does not have regular actions. So we create one here temporarily.
    ApplicationController.class_eval do
      def show
        request.variant = params[:variant].try(:to_sym)
        head :ok
      end

      def update
        # current_account.tickets.first.update_attributes!(closed_at: DateTime.now)
        head :ok
      end

      def not_authorized
        authorize NotAuthorized
      end

      def param_missing
        flash[:alert] = "Any message"

        unless request.format.js?
          redirect_to root_path
        end
      end
    end
  end

  after(:each) do
    ApplicationController.class_eval do
      remove_method(:show)
      remove_method(:update)
      remove_method(:not_authorized)
      remove_method(:param_missing)
    end

    # Be sure to reload routes after the tests run, otherwise all your
    # other controller tests will fail
    Rails.application.reload_routes!
  end

  #----------------------------------------------------------------------------
  describe 'Pundit::NotAuthorizedError' do
    it 'redirects user to dashboard in case of regular request' do
      get :not_authorized

      expect(flash[:alert]).to be_present
      expect(response).to redirect_to('/')
    end

    it 'reload current page in case of js request' do
      get :not_authorized, params: {format: 'js'}

      expect(flash[:alert]).to be_present
    end
  end

  #----------------------------------------------------------------------------
  describe 'ActionController::ParameterMissing' do
    it 'redirects user to dashboard in case of regular request' do
      get :param_missing

      expect(flash[:alert]).to be_present
      expect(response).to redirect_to('/')
    end

    it 'reload current page in case of js request' do
      get :param_missing, params: {format: 'js'}

      expect(flash[:alert]).to be_present
    end
  end

  #----------------------------------------------------------------------------
  describe '#set_variant' do
    it 'sets layout and variant to `print` depending on params[:variant]' do
      get :show, params: {variant: 'print'}

      expect(response).to have_http_status(:success)
      expect(request.variant).to eq([:print])
    end
  end

  #----------------------------------------------------------------------------
  describe '#set_time_zone' do
    it 'sets time zone to current users time zone' do
      @admin.update_column(:time_zone, 'Azores')
      get :show

      expect(Time.zone.name).to eq('Azores')
    end
  end

end
