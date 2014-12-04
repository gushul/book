class AdminController < ApplicationController
  before_filter :authenticate
  layout 'admin'

  def index
    render params[:page]     
  end

  def reservation_index
    fetch_reservations
    render 'admin/reservations/index'
  end

  def reservation_create
    @reservation = Reservation.new
    @restaurants = Restaurant.all

    render 'admin/reservations/create'
  end

  def reservation_edit
    @reservation = Reservation.find(params[:id])
    @restaurants = Restaurant.all
    render 'admin/reservations/edit'
  end

  def reservation_delete
    Reservation.find(params[:id]).destroy
    redirect_to admin_reservations_path
  end

  def reservation_update
    # Rails 3 does not have update_columns, so we use this to avoid validations
    reservation = Reservation.find(params[:id])
    
    if reservation.update_attributes!(params[:reservation])
      flash[:notice] = 'Reservation updated successfully'

      redirect_to admin_reservations_path
      return
    else
      flash[:error] = "Couldn't update reservation"
      render :reservation_edit
      return
    end
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

  private

  def fetch_reservations
    @reservations = Reservation.all
  end
end