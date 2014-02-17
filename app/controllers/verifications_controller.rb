# encoding: utf-8
class VerificationsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /verifications
  # GET /verifications.json
  def index
    redirect_to root_url , notice: 'You already verified your account.' if current_user.verified
  end  

  # POST /verifications
  # POST /verifications.json
  def create
    @code = params[:verify_code]

    respond_to do |format|
      if current_user.verify_code.to_i == @code.to_i
        current_user.update_attributes(verified: true)
        format.html { redirect_to root_url, notice: 'You\'re successfully verified your account.' }
        # format.json { render json: @restaurant, status: :created, location: @restaurant }
      else
        format.html { 
          flash[:alert] = 'Incorrect code'
          redirect_to verification_path
        }
        # format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

end