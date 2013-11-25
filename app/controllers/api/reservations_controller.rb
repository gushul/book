# TODO: rework 
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

    begin
      @restaurant = Restaurant.find(params[:reservation][:restaurant_id])
    rescue
      render json: "{\"reservation\":{\"restaurant_id\":[\"Invalid Restaurant ID\"]}}", status: 400 
      return
    end

    begin
      found = false
      date = params[:reservation][:date].to_date
      @restaurant.inventories.each do |inv|
        if inv.date.year == date.year && inv.date.month == date.month && inv.date.day == date.day
          found = true
        end
      end
      unless found
        raise "No inventory"
      end
    rescue
      render json: "{\"reservation\":{\"date\":[\"No Inventory in this day\"]}}", status: 400
      return
    end

    @reservation = Reservation.new(params[:reservation])
    @reservation.user_id = @use
    # r.id

    respond_to do |format|
      if @reservation.save 
        Reward.create( user_id: @reservation.user_id, 
                       reservation_id: @reservation.id, 
                       points_total: 5*@reservation.party_size, 
                       points_pending: 5*@reservation.party_size,    
                       description: "")
        
        format.json { render json: @reservation, status: 200 }

        # UserMailer.booking_create(current_user, @reservation).deliver
        # OwnerMailer.booking_create(@reservation).deliver
      else
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
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

        # UserMailer.booking_create(current_user, @reservation).deliver
        # OwnerMailer.booking_create(@reservation).deliver
      else
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def check_user_auth_params

      if params[:user].blank? or params[:user][:email].blank? or
         params[:user][:password].blank?
        respond_to do |format|
          format.json { render json: "Provide CORRECT login/pass parameters for this action", 
                      status: 403 }
        end
      elsif params[:user].length > 2
        respond_to do |format|
          format.json { render json: "Provide ONLY needed parameters for this action", 
                      status: 400 }
        end
      else 
        @user = User.where("email = ?", params[:user][:email] ).first
        if @user.nil? or !@user.valid_password?(params[:user][:password])
          respond_to do |format|
            format.json { render json: "Incorect login/pass", 
                      status: 403 }
          end
        end
      end

  end

  def check_reservations_params

      if params[:reservation].blank? or 
            params[:reservation][:active].blank?     or params[:reservation][:date].blank?         or 
            params[:reservation][:party_size].blank? or params[:reservation][:start_time].blank?   or 
            params[:reservation][:end_time].blank?   or params[:reservation][:restaurant_id].blank?
        respond_to do |format|
          format.json { render json: "Provide CORRECT reservation parameters data for this action", 
                      status: 400 }
        end
      elsif params[:reservation].length > 7 or params.length > 6
        respond_to do |format|
          format.json { render json: "Provide ONLY needed parameters for this action", 
                      status: 400 }
        end
      # elsif JSON.is_json?(params)
      #   respond_to do |format|
      #     format.json { render json: "Provide CORRECT json parameters for this action", status: :unprocessable_entity }
      #   end
      end

  end 

end

 