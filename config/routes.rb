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
      root :to => 'surveys#index', as: :authenticated_user_root
    end
    get "sign_up/:id", :to => "users/registrations#new", as: :new_company_user_registration
  end

  namespace :admins do
    resources :companies
    resources :surveys do
      resources :surveys_companies, only:[:index, :create, :update]
    end
  end

  resources :surveys, only: [:index, :show] do
    resources :surveys_users, only: [:new, :create, :edit, :update]
    resources :questions, only: :destroy
    resources :questions_choises, only: :destroy
  end

  resources :users, only: [:index, :destroy] do
    member do
      patch :change_chief
    end
  end

end
