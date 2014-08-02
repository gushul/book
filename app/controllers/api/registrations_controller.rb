class Api::RegistrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  respond_to :json

  # POST /registrations.json
  def create
    user = User.new(params[:user])
    if user.save
      user = user.as_json(auth_token: user.authentication_token, email: user.email)
      %w{uid provider verify_code 
        updated_at created_at}.each {|k| user.delete(k)}
      user[:password] = params[:user][:password]
      render json: user, status: 200
      return
    else
      warden.custom_failure!
      render text: "ERR:#{user.errors.full_messages.to_s}", status: 422 unless user.errors.blank?     
    end
  end

end