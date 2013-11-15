# encoding: utf-8
class Api::VerificationsController < ApplicationController
  
  before_filter :check_user_auth_params

  # POST /verifications
  # POST /verifications.json
  def create
    @code = params[:user][:verify_code]

    respond_to do |format|
      if @user.verify_code == @code.to_i
        @user.update_attributes(verified: true)
        format.json { render json: "Verified successfully", 
                             status: 200 }
      else
        format.json { render json: "Incorrect verification code", 
                             status: :unprocessable_entity }
      end
    end
  end

private

  def check_user_auth_params

      if params[:user].blank? or params[:user][:email].blank? or
         params[:user][:password].blank? or params[:user][:verify_code].blank?
        respond_to do |format|
          format.json { render json: "Provide CORRECT login/pass parameters for this action", 
                      status: 403 }
        end
      elsif params[:user].length > 3
        respond_to do |format|
          format.json { render json: "Provide ONLY needed parameters for this action", 
                      status: 400 }
        end
      else 
        @user = User.where("email = ?", params[:user][:email] ).first
        if @user.nil? or !@user.valid_password?(params[:user][:password])
          respond_to do |format|
            format.json { render json: "Incorect login/pass", 
                      status: 403 }
          end
        end
      end

  end

end