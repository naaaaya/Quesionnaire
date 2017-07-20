Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions:     'admins/sessions',
    password:     'admins/password',
    registration: 'admins/registration'
  }

  namespace :admins do
  resources :companies
end
  root 'admins/companies#index'



end
