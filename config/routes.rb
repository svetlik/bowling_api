Rails.application.routes.draw do
  namespace :api do
    resources :games, only: [:index, :create, :show, :update]
  end
end
