AuthApp::Application.routes.draw do

  root :to => "home#index"
  get "home/index"
  get 'search', to: 'home#search', as: 'search'
  get 'search_with_date_time', to: 'home#search_with_date_time', as: 'search_with_date_time'
  get 'check_availability', to: 'home#check_availability', as: 'check_availability'
  get 'home/autocomplete_restaurant_name'  

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
      post "/inventories/update"   => "inventories#update"

      post "/notes"                => "notes#index"
      post "/notes/create"         => "notes#create"
      post "/notes/update"         => "notes#update"
      post "/notes/delete"         => "notes#delete"
      
      post "/customers_info"       => "customer_informations#index"
      
      post "/restaurant/update"    => "restaurants#update"

      post "/create_vip"           => "vips#create"
      post "/delete_vip"           => "vips#delete"

      post "/tags/create"          => "tags#create"
      post "/tags/delete"          => "tags#delete"

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

  resources :vips
  delete 'vips' => "vips#destroy"

  resources :owner_dashboards, :only => [:index] do 
    get 'customers_index' => "owner_dashboards#customers_index", :on => :collection, :as => :customers_index
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
  resources :restaurants do
    get 'all' => "restaurants#index_all", :on => :collection, :as => :all
  end
  get 'restaurants/:id/:datepicker/:timepicker/:people/:status' => 'restaurants#show', :as => 'book_restaurant'
   
end
