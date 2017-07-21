Rails.application.routes.draw do
  root 'companies#index'
  devise_for :admins, controllers: {
    sessions:     'admins/sessions',
    password:     'admins/password',
    registration: 'admins/registration'
  }
    devise_for :users, controllers: {
    sessions:     'users/sessions',
    password:     'users/password',
    registration: 'users/registration'
  }

  scope :admins do
  resources :companies
end



end
