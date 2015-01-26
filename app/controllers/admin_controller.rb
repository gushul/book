class AdminController < ApplicationController
  before_filter :authenticate
  layout 'admin'

  def index
    render params[:page]     
  end

  def apple_push_index
    render 'admin/apple/index'
  end

  def apple_push_send
#    send_apple_message(params[:token], params[:message])
    @users = User.where("users.apple_device_id IS NOT NULL")
    @users.each do |u|
      puts u.email
      Resque.enqueue(ApnJob, u.apple_device_id, "msg:#{params[:message]}")
    end
    flash[:notice] = 'Apple message sent'
    render 'admin/apple/index'
#    render nothing: true
  end
  
  def android_push_index
    render 'admin/android/index'
  end

  def android_push_send
#    send_apple_message(params[:token], params[:message])
    @users = User.where("users.android_device_id IS NOT NULL")
    @users.each do |u|
      Resque.enqueue(GcmJob, u.android_device_id, "msg:#{params[:message]}")
    end
    flash[:notice] = 'Android message sent'
    render 'admin/android/index'
  end

  def restaurant_index
    fetch_restaurants
    render 'admin/restaurants/index'
  end
  
  def user_index
    fetch_users
    render 'admin/users/index'
  end

  def reservation_index
    fetch_reservations
    render 'admin/reservations/index'
  end

  def reservation_new
    @reservation = Reservation.new
    @restaurants = Restaurant.all

    render 'admin/reservations/new'
  end

  def reservation_create
    @reservation = Reservation.new(params[:reservation])

    if @reservation.valid?
      @reservation.save!
      flash[:notice] = "Reservation has been created!"
    else
      flash[:error] = 'Something went wrong while creating reservation'
      @restaurants = Restaurant.all
      render 'admin/reservations/new'
      return
    end

    redirect_to admin_reservations_path

  end

  def reservation_edit
    @reservation = Reservation.find(params[:id])
    @restaurants = Restaurant.all
    render 'admin/reservations/edit'
  end

  def reservation_delete
    Reservation.find(params[:id]).destroy
    redirect_to admin_reservations_path
    flash[:notice] = 'Reservation deleted'
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

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "user1" && password == "1234" ||
      username == "user2" && password == "1234" ||
      username == "user3" && password == "1234"
    end
  end

  private

  def fetch_reservations
    @reservations = Reservation.order('id DESC').page(params[:page]).per(1000)
  end
  
  def fetch_users
    @users = User.order('id DESC').page(params[:page]).per(1000)
  end
  
  def fetch_restaurants
    @restaurants = Restaurant.order('created_at DESC').page(params[:page]).per(1000)
  end

  def send_apple_message(token, message, certificate_path = 'config/apple_push_dev.pem')
    apn = Houston::Client.development
    apn.certificate = File.read(certificate_path)
    
    notification = Houston::Notification.new(device: token)
    notification.alert = message
    notification.custom_data = {foo: "bar"}

    apn.push(notification)
  end
end