class AdminController < ApplicationController
  before_filter :authenticate
  layout :false

  def index
    render params[:page]     
  end

  def reservation_index
    @reservations = Reservation.all
    render 'admin/reservations/index'
  end

  def reservation_create
    @reservation = Reservation.new
    @restaurants = Restaurant.all

    render 'admin/reservations/create'
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

  def authenticate
    authenticate_with_http_basic do |username, password|
      username == "user1" && password == "1234" ||
      username == "user2" && password == "1234" ||
      username == "user3" && password == "1234"
    end
  end
end