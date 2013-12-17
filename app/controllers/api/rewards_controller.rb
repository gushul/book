# encoding: utf-8
# TODO: rework 
class Api::RewardsController < ApplicationController

  # GET /rewards.json
  def index
    render json: "Incorect request. Please, use POST request with login/pass instead of GET"
  end

  # POST /rewards.json
  def create
    u = User.where("email = ?", params[:user][:email] ).first
    if u.nil? or !u.valid_password?(params[:user][:password])
#      render json: "Incorect login/pass", status: :unprocessable_entity
      render json: 'ERR:Incorrect Login/Password', status: :400
    else
      @rewards = u.rewards
      render json: @rewards
    end
  end

end   