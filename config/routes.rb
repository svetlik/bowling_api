Rails.application.routes.draw do
  namespace :api do
    match '/games' => 'games#create', via: :post
    match '/game' => 'games#show', via: :get
    match '/game' => 'games#update', via: :put
  end
end
