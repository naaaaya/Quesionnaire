Rails.application.routes.draw do



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


  devise_scope :admin do
    authenticated :admin do
      root :to => 'admins/companies#index', as: :authenticated_admin_root
    end
  end


  devise_scope :user do
    authenticated :user do
      root :to => 'users/sessions#new', as: :authenticated_user_root
    end
  end


  namespace :admins do
    resources :companies
  end



end
