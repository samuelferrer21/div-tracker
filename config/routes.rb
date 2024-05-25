Rails.application.routes.draw do
  get 'search/index'
  devise_for :users


  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  #Dashboard route
  get "dashboard", to: "dashboard#index"
  post "dashboard", to: "dashboard#create"

  get "search", to: "search#index"
  get "search/results", to: "search#index"

  #Add a stock
  post "new_holding", to: "search#add_stock"
end
