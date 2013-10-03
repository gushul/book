AuthApp::Application.routes.draw do

  root :to => "home#index"  
  # get "home/index"
  get 'search', to: 'home#search'

  resources :inventories do 
    get 'my' => "inventories#my", :on => :collection, :as => :my
    # collection do
    #   get 'my'
    # end
  end

  resources :inventory_templates do
    get 'my' => "inventory_templates#my", :on => :collection, :as => :my
  end

  resources :reservations do
    get 'my' => "reservations#my", :on => :collection, :as => :my
  end
  
  resources :restaurants
  resources :rewards
   
  devise_for :owners
  devise_for :users, controllers: { 
    omniauth_callbacks: "omniauth_callbacks" 
  }
   
end
