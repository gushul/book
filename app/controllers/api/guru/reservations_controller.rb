# encoding: utf-8
class Api::Guru::ReservationsController < ApplicationController
        
  before_filter :check_guru_auth_params

  # POST /reservations.json
  def index
    @reservations = Reservation.where(channel:50).all
    @reservations_json = []
    @reservations.each do |r|
      ro = r
      r = r.as_json
      r[:start_time] = ro.start_time_format
      %w{created_at updated_at end_time owner_id user_id}.each {|k| r.delete(k)}
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


  # POST /reservations/create
  def create
    puts "auth code: #{params[:auth][:code]}"
    pp params[:reservation]
    @restaurant = Restaurant.find(params[:reservation][:restaurant_id])
    @reservation = Reservation.new(params[:reservation])
    @reservation.end_time = @reservation.start_time + @restaurant.res_duration.minutes
    @reservation.channel = 50
    @reservation.active = true
    @reservation.ack = true

    respond_to do |format|
      if @reservation.save 
        reservation = @reservation.as_json
        %w{created_at updated_at end_time owner_id user_id}.each {|k| reservation.delete(k)}
        reservation[:start_time]  = @reservation.start_time_format
        format.json { render json: reservation, status: 200 }
      else
        format.json { render json: @reservation.errors, 
                           status: :unprocessable_entity }
      end
    end
  end

  # POST /reservations/update
  def update
    puts "auth code: #{params[:auth][:code]}"
    pp params[:reservation]
    
    @reservation = Reservation.find(params[:reservation][:id])

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        reservation = @reservation.as_json
        %w{created_at updated_at end_time owner_id user_id}.each {|k| reservation.delete(k)}
        reservation[:start_time]  = @reservation.start_time_format
        format.json { render json: reservation, status: 200 }
      else
        format.json { render json: @reservation.errors, 
                           status: :unprocessable_entity }
      end
    end
  end

private

  def check_guru_auth_params
    puts "auth code222: #{params[:auth][:code]}"
    error = false

    if params[:auth][:code] != 'aaaaaaaaaa'
      error   = true
      message = "Provide CORRECT login/pass parameters for this action"
      status  = 400
    end

    if error
      render json: message, status: status 
    end
  end
end