  # encoding: utf-8
class ReservationsController < ApplicationController
  before_filter :check_who_editing,  
                except: [:index, :show, :new, :create, :my]
  before_filter :check_for_unreg_users
  before_filter :intervals_construct,  
                only: [:new, :create, :edit, :update]

  # GET /reservations
  # GET /reservations.json
  def index
    if user_signed_in?
      @reservations = current_user.reservations
    elsif owner_signed_in?
      @reservations = []
      # current_owner.restaurants.each {|rest| @reservations += rest.reservations}
      if current_owner.restaurant.blank?
        @reservations = []
      else
        @reservations = current_owner.restaurant.reservations
      end
    end
    @reservations = @reservations.order("id desc").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end   

  def my
    @reservations = current_owner.reservations
  end   

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    @reservation = Reservation.new

    unless params[:start_time].blank?
      @reservation.start_time = params[:start_time]
      @reservation.end_time   = params[:start_time]
      @reservation.date = params[:date]
    end

    @reservation.restaurant_id = params[:restaurant_id]

    if owner_signed_in? and not current_owner.restaurant.blank?
      @duration = current_owner.restaurant.res_duration
    end 

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(params[:reservation])
    if user_signed_in?
      @reservation.user_id = current_user.id
      @reservation.channel = 1
    elsif owner_signed_in?
      @reservation.owner_id = current_owner.id
      @reservation.restaurant = current_owner.restaurant
      @reservation.channel = 6
    end

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservations_path,
                     notice: 'Reservation was successfully created.' }
      else
        format.html { render action: "new" }
        # format.html { redirect_to new_reservation_path(reservation: params[:reservation]) }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end

    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.json
  def update
    @reservation = Reservation.find(params[:id])
    if user_signed_in?
      @reservation.user_id = current_user.id
   elsif owner_signed_in?
      @reservation.owner_id = current_owner.id
      @reservation.restaurant = current_owner.restaurant
    end

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        
        # UserMailer.booking_update(current_user, @reservation).deliver
        # OwnerMailer.booking_update(@reservation).deliver

        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render json: @reservation }
      else
        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @reservation = Reservation.find(params[:id])
    @reservation.toggle!(params[:arg].to_sym)
    changes = @reservation.send(params[:arg].to_sym)

    respond_to do |format|
      format.html { redirect_to reservations_path, 
                    notice: "Reservation in #{@reservation.restaurant.name} at #{@reservation.date}: '#{params[:arg]}' changed to '#{changes}'." }
      format.js
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation = Reservation.find(params[:id])
    reservation_to_email_attach = @reservation
    @reservation.destroy

   
    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

private 

  def intervals_construct
    @intervals = []
      24.times do |h| 
        4.times do |m| 
            if h<10 and m!=0
              @intervals << "0#{h}:#{m*15}" 
            elsif h<10 and m==0
              @intervals << "0#{h}:00" 
            elsif h>=10 and m!=0
              @intervals << "#{h}:#{m*15}" 
            elsif h>=10 and m==0
              @intervals << "#{h}:0#{m*15}" 
            else
              @intervals << "#{h}:#{m*15}" 
            end
        end
      end
    @intervals << "24:00"
  end

  def check_for_unreg_users
    unless owner_signed_in? or user_signed_in?
      redirect_to root_url, notice: "Sign in for viewing this section" 
    end
  end

  def check_who_editing
    @reservation = Reservation.find(params[:id])
    if @reservation.user != current_user and @reservation.restaurant.owner != current_owner
      respond_to do |format|
        format.html { 
          redirect_to @reservation, 
          alert: "It's not yours reservation 1!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    elsif @reservation.owner != current_owner and @reservation.restaurant.owner != current_owner
      respond_to do |format|
        format.html { 
          redirect_to @reservation, 
          alert: "It's not yours reservation 2!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    end
  end

end
