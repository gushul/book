# encoding: utf-8
class Api::Owner::TagsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params, except: [:index]
  
  # GET /tags
  def index
    tags = []
    RestaurantTag.all.each do |t|
      t = t.as_json
      %w{created_at updated_at}.each {|f| t.delete(f)}
      tags << t
    end
    render json: tags, status: 200
  end

  # POST /tags/create
  def create
    @tag = RestaurantTag.where(:title => params[:tag][:title]).first 
    if @tag.blank?
      @tag = RestaurantTag.new(params[:tag])
      @tag.save
    end

    respond_to do |format|
      if !@owner.restaurant.restaurant_tags.map(&:title).include?(@tag.title)
        @owner.restaurant.restaurant_tags << @tag
        format.json { render json: "Tag successfully assigned to your restaurant.", 
                           status: 200 }
      else
        format.json { render json: "This tag already assigned to your restaurant.", 
                           status: :unprocessable_entity}
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
