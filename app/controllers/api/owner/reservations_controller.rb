# TODO: rework 
class Api::Owner::ReservationsController < ApplicationController

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
    u = Owner.where("email = ?", params[:owner][:email] ).first
    if u.nil? or !u.valid_password?(params[:owner][:password])
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

end