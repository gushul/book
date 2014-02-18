# encoding: utf-8
class Api::Owner::NicknamesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /nicknames.json
  def index
    @nicknames = @owner.restaurant.nicknames
    @nicknames_json = []
    @nicknames.each do |r|
      r = r.as_json
      %w{created_at updated_at restaurant_id}.each {|k| r.delete(k)}
      @nicknames_json << r
    end
    
    respond_to do |format|
      unless @nicknames.blank?
        format.json { render json: @nicknames_json, status: 200 }
      else
        format.json { render json: "No nicknames yet", status: 200 }
      end
    end
  end

  # POST /nicknames/create
  def create
    @nickname = Nickname.new(params[:nickname])
    @nickname.restaurant_id = @owner.restaurant.id

    respond_to do |format|
      if @nickname.save 
        format.json { render json: @nickname, status: 200 }
      else
        format.json { render json: @nickname.errors, 
                           status: :unprocessable_entity }
      end
    end
    
  end

  # POST /nicknames/update
  def update
    @nickname = @owner.restaurant.nicknames.find(params[:nickname][:id])

    respond_to do |format|
      if @nickname.present? && @nickname.update_attributes(nickname: params[:nickname][:nickname])
        format.json { render json: @nickname, status: 200  }
      else
        format.json { render json: @nickname.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /nicknames/delete
  def delete
    @nickname = @owner.restaurant.nicknames.where(id: params[:nickname][:id]).first

    respond_to do |format|
      if @nickname.present? && @nickname.destroy
        format.json { render json: "Successfully", status: 200  }
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