# encoding: utf-8
class Api::Owner::ReservationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  before_filter :check_reservations_params, only: [:create, :update]

  # POST /reservations.json
  def index
    @reservations = @owner.restaurant.reservations
    @reservations_json = []
    @reservations.each do |r|
      r = r.as_json
      # r[:quality] = rand(10)
      user = User.where(id: r[:user_id]).first
      if user.present?
        if user.reservations.blank?
          r[:quality] = 100
        else
          r[:quality] = ( user.reservations.map(&:active).flatten.count(true) - user.reservations.map(&:no_show).flatten.count(true) ) / user.reservations.map(&:active).flatten.count(true)
        end
      else
        # non registered user
        res = Reservation.where(email: r[:email], phone: r[:phone], name: r[:name] )
        if res.blank?
          r[:quality] = 100
        else
          r[:quality] = ( res.map(&:active).flatten.count(true) - res.map(&:no_show).flatten.count(true) ) / res.map(&:active).flatten.count(true)
        end
      end
      # %w{user_id}.each {|k| r.delete(k)}
      @reservations_json << r
    end
    
    respond_to do |format|
      unless @reservations.blank?
        format.json { render json: @reservations_json, status: 200 }
      else
        format.json { render json: "No reservations yet", status: 200 }
      end
    end
  end

  # POST /reservation.json
  def show
    @reservation = @owner.restaurant.reservations.where(:id => params[:reservation][:id] ).first
    respond_to do |format|
      if @reservation.present?
        format.json { render json: @reservation, status: 200 }
      else
        format.json { render json: "Incorect reservation id", status: 400 }
      end
    end
  end

  # POST /reservations/create
  def create
    @reservation = Reservation.new(params[:reservation])
    @reservation.owner_id = @owner.id

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
    # @reservation.owner_id = @owner.id

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        format.json { render json: @reservation, status: 200 }
      else
        format.json { render json: @reservation.errors, 
                           status: :unprocessable_entity }
      end
    end
  end

  # POST /reservations/delete
  def delete
    @reservation = @owner.reservations.where(:id => params[:reservation][:id] ).first

    respond_to do |format|
      if @reservation.present?
        @reservation.destroy
        format.json { render json: "Reservation #{params[:reservation][:id]} was removed", 
                             status: 200  }
      else
        format.json { render json: "Incorect reservation id", 
                             status: 400 }
      end
    end
  end

private

  def check_owner_auth_params
    error = false
    if params[:owner].blank? or
          %w{email password}.map {|el| params[:owner].has_key?(el) }.include?(false) or
          params[:owner].values.any?(&:blank?)
      error   = true
      message = "Provide CORRECT login/pass parameters for this action"
      status  = 403
    elsif params[:owner].length > 2
      error   = true
      message = "Provide ONLY needed parameters for this action"
      status  = 400
    else 
      # will be used in create and update
      @owner = Owner.where(:email => params[:owner][:email] ).first
      if @owner.nil? or !@owner.valid_password?(params[:owner][:password])
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
            %w{restaurant_id date party_size start_time end_time active name email phone}.map {|el| params[:reservation].has_key?(el) }.include?(false) or
            params[:reservation].values.any?(&:blank?)
        error   = true
        message = "Provide EVERY & CORRECT reservation parameters data for this action"
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