# encoding: utf-8
class Api::UsersController < Api::BaseController
  

  before_filter :check_user_auth_params, except: [:reset_password]

  # POST /me
  def show
    if params[:user][:android_device_id] || params[:user][:apple_device_id]
      @user.android_device_id = params[:user][:android_device_id] if !params[:user][:android_device_id].nil?
      @user.apple_device_id = params[:user][:apple_device_id] if !params[:user][:apple_device_id].nil?
      @user.save!
    end
    @user_json = @user.as_json
    %w{created_at updated_at provider uid verify_code}.each {|k| @user_json.delete(k)}
    respond_to do |format|
      if @user.present?
        format.json { render json: @user_json, status: 200 }
      else
        format.json { render json: "Err", status: 400 }
      end
    end
  end

  def reset_password
    @user=User.where("email = ?", params[:user][:email] ).first
    respond_to do |format|
      if @user.present?
        @user.send_reset_password_instructions
        format.json { render json: t('devise.confirmations.send_instructions').to_json, status: 200 }
      else
        format.json { render json: "Err", status: 400 }
      end
    end
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
      elsif params[:user].length > 5
        respond_to do |format|
          format.json { render json: "Provide ONLY needed parameters for this action", 
                      status: 400 }
        end
      else 
        @user = User.where("email = ?", params[:user][:email] ).first
        if @user.nil?
          respond_to do |format|
            format.json { render json: "No such user", 
                      status: 403 }
          end
        elsif !@user.valid_password?(params[:user][:password])
          respond_to do |format|
            format.json { render json: "Incorect login/pass", 
                      status: 403 }
          end
        end
      end

  end

end