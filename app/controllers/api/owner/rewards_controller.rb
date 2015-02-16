# encoding: utf-8
class Api::Owner::RewardsController < ApplicationController

  before_filter :check_owner_auth_params

  # POST /rewards.json
  def index    
    @rewards = Reward.where("restaurant_id = ? AND reservation_id IS NULL", @owner.restaurant.id)
    
#    @owner.restaurant.rewards
    @rewards_json = []
    @rewards.each do |r|
      ro = r
      r = r.as_json
      # %w{user_id}.each {|k| r.delete(k)}
      @rewards_json << r
    end
    
    respond_to do |format|
      unless @rewards.blank?
        format.json { render json: @rewards_json, status: 200 }
      else
        format.json { render json: "No rewards yet", status: 200 }
      end
    end
  end


  # POST /reservations/update
  def update
    @reward = Reward.find(params[:reward][:id])
    params[:reward].delete :id
    
    

    respond_to do |format|
      if @reward.update_attributes(params[:reward]) && @owner.restaurant.id == @reward.restaurant_id
        reward = @reward.as_json
        format.json { render json: reward, status: 200 }
      else
        format.json { render json: @reward.errors, 
                           status: :unprocessable_entity }
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
#    elsif params[:owner].length > 2  # increased to 3 to support device id
    elsif params[:owner].length > 3
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