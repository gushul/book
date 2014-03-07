# encoding: utf-8
class RewardsController < ApplicationController
  # before_filter :authenticate_owner!
  
  # GET /rewards
  # GET /rewards.json
  def index
    if user_signed_in?
      @rewards = current_user.rewards
    else
      @rewards = Reservation.where(restaurant_id: current_owner.restaurant.id ).map{|r| r.reward}.compact
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rewards }
    end
  end  

  # GET /rewards/1
  # GET /rewards/1.json
  def show
    @reward = Reward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reward }
    end
  end

end