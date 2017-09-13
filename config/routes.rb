Rails.application.routes.draw do
  namespace :v1 do
    post 'user_token' => 'user_token#create'
    get 'ping' => 'table_tennis#ping'
    resources :classifieds, only: [:show, :index, :create, :update, :destroy]
    resources :users, only: :show
  end
end
