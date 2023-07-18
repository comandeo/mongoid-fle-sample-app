Rails.application.routes.draw do
  resources :bank_accounts

  resources :transactions, only: %i[new create]

  # Defines the root path route ("/")
  root 'bank_accounts#index'
end
