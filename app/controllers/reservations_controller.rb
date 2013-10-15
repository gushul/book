# encoding: utf-8
class ReservationsController < ApplicationController
  # before_filter :authenticate_user!,  #!!!!!!!!!!!!!!!!!!!!
  #               except: [:index, :show, :new, :create, :my]
  # before_filter :authenticate_user_or_owner,  #!!!!!!!!!!!!!!!!!!!!
  #               except: [:index, :show, :new, :create, :my]
  before_filter :check_who_editing,  
                except: [:index, :show, :new, :create, :my]
  before_filter :check_for_unreg_users
  # before_filter :process_reservation,  
  #               only: [:create, :update, :delete]

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

        # @reservations_by_date = @reservations.group_by(&:date)
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @day = @date.day

        @quantity = []
        4.times {|i| @quantity[i] = []}
        current_owner.restaurant.inventory_templates.each do |it|
          m = it.start_time.strftime("%M").to_i
          m == 0 ? 0 : m = m/15
          h = it.start_time.strftime("%H").to_i
          @quantity[m][h] = it.quantity_available
        end
        @reservations.each do |r|
          if r.date == @date
            m1 = r.start_time.strftime("%M").to_i
            m1 == 0 ? 0 : m1 = m1/15
            m2 = r.end_time.strftime("%M").to_i
            m2 == 0 ? 0 : m2 = m2/15
            h1 = r.start_time.strftime("%H").to_i
            h2 = r.end_time.strftime("%H").to_i
            if h1 == h2 and (m2 - m1) > 0
              (m2 - m1).times {|t| @quantity[m1+t][h1] -= r.party_size }
            elsif h1 != h2
              (h2 - h1 + 1).times do |th| 
                unless th == h2 - h1
                  4.times {|tm| @quantity[m1 + tm][h1 + th] -= r.party_size }
                else
                  (m2 - m1).times {|tm| @quantity[m1 + tm][h1 + th] -= r.party_size }
                end
              end
            end
          end
        end

      end
    end

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
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    @reservation = Reservation.new
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
    elsif owner_signed_in?
      @reservation.owner_id = current_owner.id
      @reservation.restaurant = current_owner.restaurant
    end

    respond_to do |format|
      if @reservation.save

        if user_signed_in?
          Reward.create( user_id: @reservation.user_id, 
                       reservation_id: @reservation.id, 
                       points_total: 5*@reservation.party_size, 
                       points_pending: 5*@reservation.party_size,    
                       description: "")
        end
        
        if user_signed_in?
          format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
          format.json { render json: @reservation, status: :created, location: @reservation }
        else
          format.html { redirect_to root_url, notice: 'Reservation was successfully created.' }
        end

        # UserMailer.booking_create(current_user, @reservation).deliver
        # OwnerMailer.booking_create(@reservation).deliver
        
      else
        format.html { render action: "new" }
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @reservation = Reservation.find(params[:id])
    @reservation.toggle!(params[:arg].to_sym)

    respond_to do |format|
      format.html { redirect_to reservations_path, notice: "Reservation in #{@reservation.restaurant.name} at #{@reservation.date} changed." }
      format.js
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation = Reservation.find(params[:id])
    reservation_to_email_attach = @reservation
    @reservation.destroy

    # UserMailer.booking_removed(current_user, reservation_to_email_attach).deliver
    # OwnerMailer.booking_removed(reservation_to_email_attach).deliver

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

private 

  def check_for_unreg_users
    unless owner_signed_in? or user_signed_in?
      redirect_to root_url, notice: "Sign in for viewing this section" 
    end
  end

  def check_who_editing
    @reservation = Reservation.find(params[:id])
    if @reservation.user != current_user
      respond_to do |format|
        format.html { 
          redirect_to @reservation, 
          alert: "It's not yours reservation!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    elsif @reservation.owner != current_owner
      respond_to do |format|
        format.html { 
          redirect_to @reservation, 
          alert: "It's not yours reservation!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    end
  end

end
