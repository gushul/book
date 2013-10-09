# encoding: utf-8
# TODO: rework 
class Api::RewardsController < ApplicationController
  
  # POST /rewards.json
  def create
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
      render json: "Incorect login/pass", status: :unprocessable_entity
    else
      @rewards = u.rewards
      render json: @rewards
    end
  end

end