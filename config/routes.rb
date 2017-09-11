Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  get 'ping' => 'application#ping'

  resources :classifieds, only: [:show, :index]
end
