class RewardsController < ApplicationController
  # before_filter :authenticate_owner!
  
  # GET /rewards
  # GET /rewards.json
  def show
    @reward = Reward.find(params[:id])
  end

end