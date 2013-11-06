# TODO: rework 
class Api::ReservationsController < ApplicationController
  before_filter :check_params, only: [:create, :update]

  # GET /reservations.json
  def index
    render json: "Incorect request. Please, use POST request with login/pass instead of GET" 
  end

  # GET /reservations/1.json
  def show
    render json: "Incorect request. Please, use POST request with login/pass instead of GET to view the particular reservation"  
  end

  # POST /reservations.json
  def create
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
      render json: "Incorect login/pass", status: :unprocessable_entity
    else
      unless params[:reservation].blank?

        @reservation = Reservation.new(params[:reservation])
        @reservation.user_id = u.id

        respond_to do |format|
          if @reservation.save 
            Reward.create( user_id: @reservation.user_id, 
                         reservation_id: @reservation.id, 
                         points_total: 5*@reservation.party_size, 
                         points_pending: 5*@reservation.party_size,    
                         description: "")
            
            format.json { render json: @reservation, status: :created }

            # UserMailer.booking_create(current_user, @reservation).deliver
            # OwnerMailer.booking_create(@reservation).deliver
          else
            format.json { render json: @reservation.errors, status: :unprocessable_entity }
          end
        end

      else
        @reservations = u.reservations
        render json: @reservations 
      end

    end
  end

  # PUT /reservations/1.json
  def update
    @reservation = Reservation.find(params[:id])
    u = User.where("email = ?", params[:user][:email] ).first
    unless u.valid_password?(params[:user][:password])
      render json: "Incorect login/pass", status: :unprocessable_entity
    else
      @reservation.user_id = u.id

      respond_to do |format|
        if @reservation.update_attributes(params[:reservation])
          
          format.json { head :no_content }

          # UserMailer.booking_create(current_user, @reservation).deliver
          # OwnerMailer.booking_create(@reservation).deliver
          
        else
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      end
 
    end

  end

private

  def check_params

      if params[:user].blank? or params[:user][:email].blank? or
         params[:user][:password].blank?
        respond_to do |format|
          format.json { render json: "Provide correct login/pass for this action", 
                      status: :unprocessable_entity }
        end
      # elsif params[:reservation].blank? or 
      #       params[:reservation][:active].blank?     or params[:reservation][:date].blank?         or 
      #       params[:reservation][:party_size].blank? or params[:reservation][:start_time].blank?   or 
      #       params[:reservation][:end_time].blank?   or params[:reservation][:restaurant_id].blank?
      #   respond_to do |format|
      #     format.json { render json: "Provide correct reservation data for this action", 
      #                 status: :unprocessable_entity }
      #   end
      # elsif params[:reservation].length > 6 or params[:user].length > 2
      #   respond_to do |format|
      #     format.json { render json: "Provide ONLY needed parameters parameters for this action", 
      #                 status: :unprocessable_entity }
      #   end
      # elsif JSON.is_json?(params)
      #   respond_to do |format|
      #     format.json { render json: "Provide CORRECT json parameters for this action", status: :unprocessable_entity }
      #   end
      end

  end 

end

# 
# curl -X POST -H "Content-Type: application/json" -d '{ "user":{"email":"user1@mail.com","password":"secret12"}, "reservation":{"restaurant_id":1, "date": "2013-11-5 20:00:00", "start_time": "2013-11-5 11:00:00", "end_time": "2013-10-20 12:00:00", "party_size":13, "active": false } }' http://localhost:3000/api/reservations.json
