Rails.application.routes.draw do
  root to: 'dashboard_widgets#dashboard'

  devise_for :users

  resources :users do
    collection do
      patch :bulk_update
    end

    member do
      patch :request_password_reset
    end
  end

  resources :roles do
    get :edit_all, on: :collection
    patch :update_all, on: :collection
  end

  resources :email_notifications, only: [:index, :edit, :update] do
    patch :quick_toggle, on: :member
  end
  resource :email_settings, only: [:edit, :update]
  resources :settings, only: [:index]

  resources :dashboard_widgets, except: [:new, :index] do
    get :dashboard, on: :collection
    patch :update_positions, on: :collection
  end
end
