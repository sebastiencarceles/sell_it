Rails.application.routes.draw do
  get 'ping' => 'application#ping'

  resources :classifieds, only: [:show, :index]
end
