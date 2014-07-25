# encoding: utf-8
class Api::Owner::RestaurantsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params

  # POST /restautant/show
  def show
    @restaurant = @owner.restaurant
    if params[:ver].to_i == 2
      cover_pic = @restaurant.photos.covers.first
      no_cover_pics = @restaurant.photos.no_covers
      @restaurant[:images] = {}
      if cover_pic.present?
        h = Hash["v100x100" => cover_pic.picture.url(:v100x100)]
        h.merge!("v280x160" => cover_pic.picture.url(:v280x160))
        h.merge!("v600x480" => cover_pic.picture.url(:v600x480))
        @restaurant[:images][:cover] = h 
      end
      no_cover_pics.each_with_index do |p, ind|
        h = Hash["v100x100" => p.picture.url(:v100x100)]
        h.merge!("v280x160" => p.picture.url(:v280x160))
        h.merge!("v600x480" => p.picture.url(:v600x480))
        @restaurant[:images]["#{ind}"] = h
      end
    end
    respond_to do |format|
      if @restaurant.present?
        format.json { render json: @restaurant, status: 200 }
      else
        format.json { render json: "You have not created restaurant yet.", status: 400 }
      end
    end
  end

  # POST /restaurant/update
  def update
    @restaurant = @owner.restaurant

    respond_to do |format|
      if @restaurant.present? && @restaurant.update_attributes(params[:restaurant])
        format.json { render json: @restaurant, status: 200 }
      else
        format.json { render text: "ERR:#{@restaurant.errors.to_s}", status: 400 }
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