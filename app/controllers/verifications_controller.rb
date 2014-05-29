# encoding: utf-8
class VerificationsController < ApplicationController
  before_filter :authenticate_user!
  
  # POST /verifications
  # POST /verifications.json
  def create
    @code = params[:verify_code]

    respond_to do |format|
      if current_user.verify_code.to_i == @code.to_i
        current_user.update_attributes(verified: true)
        format.html { redirect_to user_dashboards_path, notice: 'You\'re successfully verified your account.' }
        # format.json { render json: @restaurant, status: :created, location: @restaurant }
      else
        format.html { 
          flash[:alert] = 'Incorrect code'
          redirect_to verify_user_dashboards_path
        }
        # format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /verifications
  def resend
    message = 'You already verified your account.'
    route = user_dashboards_path
    unless current_user.verified
      current_user.send_verification_code_via_sms
      route = verify_user_dashboards_path
      message = 'We re-sent code to you phone.'
    end
    redirect_to route, notice: message
  end 

end