Rails.application.routes.draw do
  devise_for :users

  resources :bank_accounts
  resources :transactions, only: %i[new create]

  namespace :admin do
    resources :users
    resources :dashboards, only: [:index]
    resources :keys
    root 'dashboards#index'
  end

  # Defines the root path route ("/")
  root 'bank_accounts#index'
  get '/admin', to: 'dashboard#index'
end
