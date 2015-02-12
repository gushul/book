# encoding: utf-8
class Api::Owner::InventoriesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /inventories.json
  def index
    @inventories = @owner.restaurant.inventories.future
    @inventories_json = []
    @inventories.each do |r|
      r.start_time = r.start_time.utc
      r.end_time = r.end_time.utc
      r = r.as_json
#      %w{created_at updated_at restaurant_id end_time}.each {|k| r.delete(k)}
      %w{created_at updated_at restaurant_id id}.each {|k| r.delete(k)}
      @inventories_json << r
    end
    
    respond_to do |format|
      unless @inventories.blank?
        format.json { render json: @inventories_json, status: 200 }
      else
        format.json { render json: "No inventories yet", status: 200 }
      end
    end
  end

  # POST /inventories/update
  def update
    @inventory = @owner.restaurant.inventories.find(params[:inventory][:id])
    @inventory.end_time = @inventory.start_time + 15.minutes

    respond_to do |format|
      if @inventory.update_attributes(params[:inventory])
        format.json { render json: @inventory, status: 200  }
      else
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /inventories/update_in_time_frame
  def update_in_time_frame
    qa = params[:quantity_available] ? params[:quantity_available] : 0
    start_period = params[:start_period]
    end_period = params[:end_period]
    
    puts "start_period: #{start_period.to_date} #{start_period}"
    puts "end_period: #{end_period.to_date} #{end_period}"
    
    
    if start_period.to_date == end_period.to_date then
      i = Inventory.where(:date => start_period.to_date, :restaurant_id => @owner.restaurant.id,
                    :start_time => "2000-01-01 #{start_period.to_time.strftime('%H:%M')}:00".to_time..."2000-01-01 #{end_period.to_time.strftime('%H:%M')}:00".to_time)
    else
      i = []
      start_day = Inventory.where(:date => start_period.to_date, :restaurant_id => @owner.restaurant.id,
                    :start_time => "2000-01-01 #{start_period.to_time.strftime('%H:%M')}:00".to_time..."2000-01-01 23:45".to_time)
      puts "start_day: #{start_day.count}"
      
      end_day = Inventory.where(:date => end_period.to_date, :restaurant_id => @owner.restaurant.id,
                    :start_time => "2000-01-01 00:00".to_time..."2000-01-01 #{end_period.to_time.strftime('%H:%M')}:00".to_time)
      puts "end_day: #{end_day.count}"
      
      middle_day = Inventory.where(:date => start_period.to_date+1.day...end_period.to_date, :restaurant_id => @owner.restaurant.id)
      puts "middle_day: #{middle_day.count}"

      i << middle_day << end_day << start_day
      i = i.flatten

#      render json: "OK", status: 200

#      @inventories = i.flatten
#      @inventories = nil
    end
    
    
    i.each do |b|
      b.quantity_available = qa
      b.save
    end
    
#    puts @inventories.count
          
#    @inventories = @owner.restaurant.inventories.in_frame(params[:start_period], params[:end_period])


    respond_to do |format|
#      if @inventories.update_all(quantity_available: qa)
        format.json { render json: { status: "OK", count: i.count}, status: 200 }
#      else
#        format.json { render json: "ERR", status: :unprocessable_entity }
#      end
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


end