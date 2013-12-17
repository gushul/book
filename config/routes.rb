AuthApp::Application.routes.draw do

  # root :to => "home#index"
  root :to => "home#index"
  get "home/index"
  get 'search', to: 'home#search', as: 'search'
  # get 'calendar', to: 'home#calendar', as: 'calendar'

  devise_for :owners
  get  'verification', to: 'verifications#index', as: 'verification'
  post 'verification', to: 'verifications#create'
  devise_for :users, controllers: { 
    omniauth_callbacks: "omniauth_callbacks" 
  }

  namespace :api do
    devise_for(:users, :controllers => {
     # :sessions => "api/sessions", 
     :registrations => "api/registrations"
     })
    post '/verification', to: 'verifications#create'
    
    # resources :reservations, :only => [:update]
    post "/reservations"        => "reservations#index"
    post "/reservations/create" => "reservations#create"
    post "/reservations/update" => "reservations#update"

    resources :rewards #, :only => [:create]
    resources :restaurants

    namespace :owner do
      post "/inventories"          => "inventories#index"
      
      post "/customers_info"       => "customer_informations#index"

      post "/reservations"         => "reservations#index"
      post "/reservation"          => "reservations#show"
      post "/reservations/create"  => "reservations#create"
      post "/reservations/update"  => "reservations#update"
      post "/reservations/delete"  => "reservations#delete"
    end
  end 

  resources :inventories do 
    get 'my' => "inventories#my", :on => :collection, :as => :my
  end

  resources :inventory_templates do
    get 'my' => "inventory_templates#my", :on => :collection, :as => :my
  end

  resources :inventory_template_groups do
    get 'my' => "inventory_template_groups#my", :on => :collection, :as => :my
  end

  resources :reservations do
    get 'my' => "reservations#my", :on => :collection, :as => :my
    put :toggle, :on => :member
  end
    
  resources :rewards
  resources :restaurants
   
   
end
