class Api::RegistrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  respond_to :json

  # POST /registrations.json
  def create
    user = User.new(params[:user])
    if user.save
      render json: user.as_json(auth_token: user.authentication_token, email: user.email), status: :created
       # render :status => 200, :json => resource
      return
    else
      warden.custom_failure!
      render json: user.errors, status: :unprocessable_entity
    end
  end
 
end