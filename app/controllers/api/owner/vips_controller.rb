# encoding: utf-8
class Api::Owner::VipsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /create_vip.json
  def create
    @vip = Vip.new(params[:vip])
    @vip.restaurant_id = @owner.restaurant.id

    respond_to do |format|
      if @vip.save 
        format.json { render json: @vip, status: 200 }
      else
        format.json { render json: @vip.errors, 
                           status: :unprocessable_entity }
      end
    end
    
  end

   # POST /delete_vip.json
  def delete
    if params[:vip][:user_id].present?
      @vip = Vip.where(:user_id => params[:vip][:user_id]).where(:restaurant_id => @owner.restaurant.id).first
    else
      @vip = Vip.where(:name => params[:vip][:name]).where(:phone => params[:vip][:phone]).where(:restaurant_id => @owner.restaurant.id).first
    end

    respond_to do |format|
      if @vip.present? && @vip.destroy
        format.json { render json: "Successfully", status: 200 }
      else
        format.json { render json: "ERR:Check parameters", 
                           status: :unprocessable_entity }
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