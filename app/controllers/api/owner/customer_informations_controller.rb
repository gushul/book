# encoding: utf-8
class Api::Owner::CustomerInformationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /customers_info.json
  def index
    @owner = Owner.where(:email => params[:owner][:email] ).first 

#    @owners = @owner.restaurant.reservations.where("name <> ?", "")
    @owners = @owner.restaurant.reservations.where("user_id IS NULL", "")
    @users  = @owner.restaurant.reservations.map {|res| res.user }.uniq

    @info_json = []
    @users.each do |r|
      info = {}
      if r.present?
        info[:name]    = r[:username]
        info[:email]   = r[:email]
        info[:phone]   = r[:phone]
        info[:user_id] = r[:id]
        if r.vips.map {|v| v.restaurant_id == @owner.restaurant.id }.include?(true)
          info[:vip] = true
        else
          info[:vip] = false
        end
        @info_json << info
      end
    end

    a = []
    @owners_new = []
    @owners.each do |res|
      if !a.include?(res.phone) then
        @owners_new << res
        a << res.phone
      end
    end
    
    
    @owners_new.each do |r|
      info = {}
      info[:name]  = r[:name]
      info[:phone] = r[:phone]
      info[:email] = r[:email]
      if Vip.where(:name => info[:name]).where(:phone => info[:phone]).where(:restaurant_id => @owner.restaurant.id).first.present?
#      if Vip.where(:phone => info[:phone]).where(:restaurant_id => @owner.restaurant.id).first.present?
        info[:vip] = true
      else
        info[:vip] = false
      end
      @info_json << info
    end
    
    respond_to do |format|
      unless @owners.blank? && @users.blank?
        format.json { render json: @info_json, status: 200 }
      else
        format.json { render json: "No customers info (no reservations)", 
                             status: 200 }
      end
    end
  end

private

  def check_owner_auth_params
    error = false
    if params[:owner].blank? or
          %w{email password}.map {|el| params[:owner].has_key?(el) }.include?(false) or
          params[:owner].values.any?(&:blank?)
      error   = true
      message = "Provide CORRECT login/pass parameters for this action"
      status  = 403
    elsif params[:owner].length > 2
      error   = true
      message = "Provide ONLY needed parameters for this action"
      status  = 400
    else 
      # will be used in create and update
      @owner = Owner.where(:email => params[:owner][:email] ).first
      if @owner.nil? or !@owner.valid_password?(params[:owner][:password])
        error   = true
        message = "Incorect login/pass"
        status  = 403
      end
    end

    if error
      render json: message, status: status 
    end
  end


end