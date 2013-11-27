# TODO: before_filters rewiew 
class Api::ReservationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_user_auth_params
  before_filter :check_reservations_params, only: [:create, :update]

  # POST /reservations
  def index
    @reservations = @user.reservations
    @reservations_json = []
    @reservations.each do |r|
      r = r.as_json
      %w{arrived email no_show owner_id}.each {|k| r.delete(k)}
      @reservations_json << r
    end

    render json: @reservations_json, status: 200 
  end

  # POST /reservations/create
  def create
    @reservation = Reservation.new(params[:reservation])
    @reservation.user_id = @user.id

    respond_to do |format|
      if @reservation.save 
        format.json { render json: @reservation, status: 200 }
      else
        format.json { render json: @reservation.errors, 
                           status: :unprocessable_entity }
      end
    end
  end

  # POST /reservations/update
  def update
    @reservation = Reservation.find(params[:reservation][:id])
    @reservation.user_id = @user.id

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        format.json { render json: @reservation, status: 200 }
      else
        format.json { render json: @reservation.errors, 
                           status: :unprocessable_entity }
      end
    end
  end

private

  def check_user_auth_params
    error = false
    if params[:user].blank? or
          %w{email password}.map {|el| params[:user].has_key?(el) }.include?(false) or
          params[:user].values.any?(&:blank?)
      error   = true
      message = "Provide CORRECT login/pass parameters for this action"
      status  = 403
    elsif params[:user].length > 2
      error   = true
      message = "Provide ONLY needed parameters for this action"
      status  = 400
    else 
      # will be used in create and update
      @user = User.where("email = ?", params[:user][:email] ).first
      if @user.nil? or !@user.valid_password?(params[:user][:password])
        error   = true
        message = "Incorect login/pass"
        status  = 403
      end
    end

    if error
      render json: message, status: status 
    end
  end

  def check_reservations_params
      error = false
      if params[:reservation].blank? or 
            %w{restaurant_id date party_size start_time end_time active}.map {|el| params[:reservation].has_key?(el) }.include?(false) or
            params[:reservation].values.any?(&:blank?)
        error   = true
        message = "Provide CORRECT reservation parameters data for this action"
        status  = 400   
      # elsif params[:reservation].length > 6 or params.length > 6
      #   error   = true
      #   message = "Provide ONLY needed parameters for this action"
      #   status  = 400  
      end

      if error
        render json: message, status: status 
      end
  end 

end

 