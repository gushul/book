class Api::RegistrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  respond_to :json

  # POST /registrations.json
  def create
    user = User.new(params[:user])
    if user.save
      send_sms(user.phone, user.verify_code)
      user = user.as_json(auth_token: user.authentication_token, email: user.email)
      %w{uid provider verify_code 
        updated_at created_at}.each {|k| user.delete(k)}
      user[:password] = params[:user][:password]
      render json: user, status: 200
      return
    else
      warden.custom_failure!
      render text: "ERR:#{user.errors.to_s}", status: 400      
    end
  end

private
  
  def send_sms(phone,verify_code)
    require 'net/https'
    require 'open-uri'
    uri = URI.parse("https://www.siptraffic.com/myaccount/sendsms.php?username=matthewfong&password=psyagbha&from=+6600000000&to=+#{phone}&text=#{verify_code}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.get(uri.request_uri)
  end

end