# encoding: utf-8
class VerificationsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /verifications
  # GET /verifications.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rewards }
    end
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
          flash[:notice] = 'Incorrect code'
          redirect_to verification_path
        }
        # format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

end