# encoding: utf-8
# TODO: rework 
class Api::RewardsController < Api::BaseController

  # GET /rewards.json
  def index
    render json: "Incorect request. Please, use POST request with login/pass instead of GET"
  end

  # POST /rewards.json
  def create
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
#      render json: "Incorect login/pass", status: :unprocessable_entity
      render json: 'ERR:Incorrect Login/Password', status: 400
    else
      puts params[:reward]
      puts params[:reward][:points_total]
      if params[:reward][:points_total].nil? 
        @rewards = u.rewards
        render json: @rewards
      elsif params[:reward][:points_total].to_i < 0
        @reward = Reward.new(params[:reward])
        @reward.user = u
        @reward.description = 'Reward Redeem'
        @reward.save
        render json: @reward
      else
        render json: 'ERR:Cannot Create Positive Points', status: 400
      end
    end
  end

end   