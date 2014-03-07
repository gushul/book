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

  # POST /create
  def create
    @reward = Reward.new(params[:reward])
    @reward.user_id = current_user.id
    @reward.points_total = (-1) * @reward.points_total

    if @reward.points_total.abs <= current_user.get_credits && @reward.save
      @reward = Reward.last
      @reward.description = "Redeemeded #{@reward.points_total.abs} Points at #{Restaurant.find(@reward.restaurant_id).name} Confirm No: #{@reward.id}"
      @reward.save
      redirect_to rewards_path, notice: 'Reward was created.'
    else
      redirect_to rewards_path, notice: "You're only have #{current_user.get_credits} credits"
    end
  end

end