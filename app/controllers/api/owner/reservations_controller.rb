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
      ro = r
      r = r.as_json
      r[:quality] = ro.quality
      r[:start_time] = ro.start_time_format
      r[:end_time] = ro.end_time_format
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
        reservation = @reservation.as_json
				reservation[:created_at] = @reservation.created_at.+7.hour
        reservation[:start_time]  = @reservation.start_time_format
        reservation[:end_time]    = @reservation.end_time_format
        format.json { render json: reservation, status: 200 }
      else
        format.json { render json: "Incorect reservation id", status: 400 }
      end
    end
  end

  # POST /reservations/create
  def create
    @reservation = Reservation.new(params[:reservation])
		
#		@reservation.date = @reservation.date+7.hour
#		@reservation.start_time = @reservation.start_time+7.hour
#		@reservation.end_time = @reservation.end_time+7.hour
		
    @reservation.owner_id = @owner.id

    respond_to do |format|
      if @reservation.save 
        reservation = @reservation.as_json
#				reservation[:date] = @reservation.date.utc
        reservation[:start_time]  = @reservation.start_time_format
        reservation[:end_time]    = @reservation.end_time_format
        format.json { render json: reservation, status: 200 }
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
        reservation = @reservation.as_json
        reservation[:start_time]  = @reservation.start_time_format
        reservation[:end_time]    = @reservation.end_time_format
        format.json { render json: reservation, status: 200 }
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