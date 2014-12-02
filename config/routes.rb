AuthApp::Application.routes.draw do

  root :to => "home#index"

  controller :home do
    get 'index' 
    get "about_us",     as: 'about_us'
    get "how_it_works", as: 'how_it_works'
    get "careers",      as: 'careers'
    get "contact_us",   as: 'contact_us'
    get "map",          as: 'map'
    
    get ":admin/:page(/:id)", as: 'admin', to: 'admin#index', 
      :constraints => {:admin => "admin", :page => /new_owner|new_restaurant|dashboard/ }
    get "admin/new_reservation" => 'admin#new_reservation'
    post "admin_owner_create",     to: 'home#admin_owner_create', as: "admin_owner_create"
    post "admin_restaurant_create", to: 'home#admin_restaurant_create', as: "admin_restaurant_create"
  end

  # post "signin_as_admin", to: 'home#admin_login'
  # namespace :admito: 'home#admin',n do
  # end

  get 'search', to: 'home#search', as: 'search'
  post 'filter', to: 'home#filter_search', as: 'filter'
  get 'search_with_date_time', to: 'home#search_with_date_time', as: 'search_with_date_time'
  get 'check_availability', to: 'home#check_availability', as: 'check_availability'
  get 'home/autocomplete_restaurant_name'  

  devise_for :owners

  devise_for :users, controllers: { 
    omniauth_callbacks: "omniauth_callbacks" 
  }

  namespace :api do
    devise_for(:users, :controllers => {
     # :sessions => "api/sessions", 
     :registrations => "api/registrations"
     })
    post '/verification',        to: 'verifications#create'
    post '/verification/resend', to: 'verifications#resend'
    
    post "/reset_password" => "users#reset_password"

    # resources :reservations, :only => [:update]
    post "/reservations"        => "reservations#index"
    post "/reservations/create" => "reservations#create"
    post "/reservations/update" => "reservations#update"
#    post "/rewards"        => "rewards#index"
    post "/rewards/create" => "rewards#create"
    
    post "/me" => "users#show"

    resources :rewards #, :only => [:create]
    resources :restaurants do 
      get 'list_restaurants' => "restaurants#list_restaurants", :on => :collection, :as => :list_restaurants
      get 'get_restaurant_availability' => "restaurants#get_restaurant_availability", :on => :collection, :as => :get_restaurant_availability
    end
    resources :restaurant_tags

    namespace :owner do
      post "/inventories"          => "inventories#index"
      post "/inventories/update"   => "inventories#update"
      post "/inventories/update_in_time_frame"   => "inventories#update_in_time_frame"

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

      get  "/tags"                 => "tags#index"
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
    get 'reservations(/:date)' => "owner_dashboards#reservations", :on => :collection, :as => :reservations
    get 'reservation/:id' => "owner_dashboards#reservation",       :on => :collection, :as => :reservation
    get 'rewards'         => "owner_dashboards#rewards",         :on => :collection, :as => :rewards
    get 'customers'       => "owner_dashboards#customers",       :on => :collection, :as => :customers
    get 'reports(/:date)' => "owner_dashboards#reports",         :on => :collection, :as => :reports
    get 'inventories(/:date)' => "owner_dashboards#inventories", :on => :collection, :as => :inventories
    get 'inventory/:id'   => "owner_dashboards#inventory",       :on => :collection, :as => :inventory
    get 'remake_inventory' => "owner_dashboards#remake_inventory",       :on => :collection, :as => :remake_inventory
  end

  resources :user_dashboards, :only => [:index] do 
    get 'reservations' => "user_dashboards#reservations", :on => :collection, :as => :reservations
    get 'rewards'      => "user_dashboards#rewards",      :on => :collection, :as => :rewards

    get  'verification',        to: 'user_dashboards#verification', :on => :collection, as: :verify
    post 'verification',        to: 'verifications#create',         :on => :collection
    get  'verification/resend', to: 'verifications#resend',         :on => :collection, as: :resend_code
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
    get 'list_restaurants' => "restaurants#list_restaurants", :on => :collection, :as => :list_restaurants
  end
  get 'restaurants/:id/:datepicker/:timepicker/:people/:status' => 'restaurants#show', :as => 'book_restaurant'
  post '/external_booking' => 'reservations#external_booking' 
end
