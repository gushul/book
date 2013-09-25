AuthApp::Application.routes.draw do

  root :to => "home#index"  
  # get "home/index"
  get 'search', to: 'home#search'
  
  resources :inventories
  resources :inventory_templates
  resources :reservations
  resources :restaurants
  resources :rewards
   
  devise_for :owners
  devise_for :users, controllers: { 
    omniauth_callbacks: "omniauth_callbacks" 
  }
   
end
