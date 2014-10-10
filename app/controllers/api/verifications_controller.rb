# encoding: utf-8
class Api::VerificationsController < Api::BaseController
  
  before_filter :check_user_auth_params

  # POST /verification
  def create
    @code = params[:user][:verify_code]

    respond_to do |format|
      if @user.verify_code.to_i == @code.to_i
        @user.update_attributes(verified: true)
        format.json { render json: "Verified successfully", 
                             status: 200 }
      else
        format.json { render json: "Incorrect verification code", 
                             status: :unprocessable_entity }
      end
    end
  end

  # POST /verification/resend
  def resend
    @user.send_verification_code_via_sms
    render json: "Done", status: 200
  end

private

  def check_user_auth_params

      if params[:user].blank? or params[:user][:email].blank? or
         params[:user][:password].blank? 
        respond_to do |format|
          format.json { render json: "Provide CORRECT login/pass parameters for this action", 
                      status: 403 }
        end
#      elsif params[:user].length > 3
      elsif params[:user].length > 4
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