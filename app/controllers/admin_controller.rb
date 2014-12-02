class AdminController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "123", only: :admin

  def index
    render params[:page], layout: false      
  end

  def admin_owner_create
    owner = Owner.new(params[:owner])

    respond_to do |format|
      if owner.save
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "new_restaurant", :id => owner.id ), 
          notice: 'Owner was successfully created.'
           }
      else
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "new_owner"), 
          notice: "#{owner.errors.messages}"
        }
      end
    end
  end

  def admin_restaurant_create
    restaurant = Restaurant.new(params[:restaurant])

    respond_to do |format|
      if restaurant.save
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "dashboard" ), 
          notice: 'Restaurant was successfully created.'
           }
      else
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "new_restaurant"), 
          notice: "#{restaurant.errors.messages}"
        }
      end
    end
  end
end