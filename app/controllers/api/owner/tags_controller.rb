# encoding: utf-8
class Api::Owner::TagsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /tags/create
  def create
    @tag = RestaurantTag.new(params[:tag])
    @owner.restaurant.restaurant_tags << @tag

    respond_to do |format|
      if @tag.save 
        format.json { render json: @tag, status: 200 }
      else
        format.json { render json: @tag.errors, 
                           status: :unprocessable_entity }
      end
    end
    
  end

   # POST /tags/delete
  def delete
    @tag = @owner.restaurant.restaurant_tags.where(:title => params[:tag][:title]).first

    respond_to do |format|
      if @tag.present?
        @owner.restaurant.restaurant_tags.delete(@tag)
        # @tag.destroy 
        format.json { render json: "Successfully", status: 200 }
      else
        format.json { render json: "ERR:Check tag title", 
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