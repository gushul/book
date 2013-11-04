AuthApp::Application.routes.draw do

  namespace :api do
    devise_for(:users, :controllers => {
     # :sessions => "api/sessions", 
     :registrations => "api/registrations"
     })
    
    resources :reservations
    resources :rewards #, :only => [:create]
    resources :restaurants

    namespace :owner do
      resources :reservations
    end
  end 

  root :to => "home#index"
  # get "home/index"
  get 'search', to: 'home#search', as: 'search'
  get 'calendar', to: 'home#calendar', as: 'calendar'

  devise_for :owners
  devise_for :users, controllers: { 
    omniauth_callbacks: "omniauth_callbacks" 
  }
  

  resources :inventories do 
    get 'my' => "inventories#my", :on => :collection, :as => :my
    # collection do
    #   get 'my'
    # end
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
