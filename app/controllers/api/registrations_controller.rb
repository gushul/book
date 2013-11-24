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
      render json: user, status: :created
       # render :status => 200, :json => resource
      return
    else
      warden.custom_failure!
      render json: user.errors, status: :unprocessable_entity
    end
  end

end