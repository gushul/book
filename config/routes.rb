AuthApp::Application.routes.draw do

  root :to => "home#index"

  controller :home do
    get 'index' 
    get "about_us",     as: 'about_us'
    get "how_it_works", as: 'how_it_works'
    get "careers",      as: 'careers'
  end

  get 'search', to: 'home#search', as: 'search'
  get 'search_with_date_time', to: 'home#search_with_date_time', as: 'search_with_date_time'
  get 'check_availability', to: 'home#check_availability', as: 'check_availability'
  get 'home/autocomplete_restaurant_name'  

  devise_for :owners
  get  'verification', to: 'verifications#index', as: 'verification'
  post 'verification', to: 'verifications#create'
  get  'verification/resend', to: 'verifications#resend', as: 'resend_code'
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

      post "/inventory_template_groups"          => "inventory_template_groups#index"
      post "/inventory_template_groups/create"   => "inventory_template_groups#create"
      post "/inventory_template_groups/update"   => "inventory_template_groups#update"

      post "/notes"                => "notes#index"
      post "/notes/create"         => "notes#create"
      post "/notes/update"         => "notes#update"
      post "/notes/delete"         => "notes#delete"
      
      post "/nicknames"            => "nicknames#index"
      post "/nicknames/create"     => "nicknames#create"
      post "/nicknames/update"     => "nicknames#update"
      post "/nicknames/delete"     => "nicknames#delete"

      post "/customers_info"       => "customer_informations#index"
      
      post "/restaurant/update"    => "restaurants#update"
      post "/restaurant/show"      => "restaurants#show"

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
    get 'account'         => "owner_dashboards#account",         :on => :collection, :as => :account
    get 'reservations'    => "owner_dashboards#reservations",    :on => :collection, :as => :reservations
    get 'rewards'         => "owner_dashboards#rewards",         :on => :collection, :as => :rewards
    get 'customers'       => "owner_dashboards#customers",       :on => :collection, :as => :customers
    get 'reports'         => "owner_dashboards#reports",         :on => :collection, :as => :reports
    get 'inventories'     => "owner_dashboards#inventories",     :on => :collection, :as => :inventories
  end

  resources :user_dashboards, :only => [:index] do 
    get 'reservations' => "user_dashboards#reservations", :on => :collection, :as => :reservations
    get 'rewards'      => "user_dashboards#rewards",      :on => :collection, :as => :rewards
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
