Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace "v1" do
    resources :rooms, only:[:index, :show, :create, :update, :destroy]
  end
end
