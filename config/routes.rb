Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace "v1" do
    resources :rooms, only:[:index, :show, :create, :update, :destroy]
    resources :tags, only:[:show]
  end
end
