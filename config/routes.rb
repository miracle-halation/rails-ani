Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace "v1" do
    resources :rooms, only:[:index, :new, :show, :create, :update, :destroy] do
      member do
        post 'join'
        post 'depart'
      end
      collection do
        post 'search'
      end
    end
    resources :tags, only:[:show]
    resources :messages, only:[:create, :update, :destroy]
    resources :friends, only: [:show, :destroy] do
      collection do
        post 'apply'
        post 'approval'
      end
    end
    get :health_check, to: 'healthcheck#index'
  end
end
