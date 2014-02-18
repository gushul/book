# encoding: utf-8
class Api::Owner::InventoryTemplateGroupsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_owner_auth_params
  
  # POST /inventory_template_groups.json
  def index
    @inventory_template_groups = @owner.restaurant.inventory_template_groups
    @inventories_json = []
    @inventory_template_groups.each do |r|
      r = r.as_json
      %w{created_at updated_at restaurant_id}.each {|k| r.delete(k)}
      @inventories_json << r
    end
    
    respond_to do |format|
      unless @inventory_template_groups.blank?
        format.json { render json: @inventories_json, status: 200 }
      else
        format.json { render json: "No inventories yet", status: 200 }
      end
    end
  end

  # POST /inventory_template_groups/create
  def create
    @inventory = InventoryTemplateGroup.new(params[:inventory_template_group])
    @inventory.restaurant_id = @owner.restaurant.id

    respond_to do |format|
      if @inventory.save 
        format.json { render json: @inventory, status: 200 }
      else
        format.json { render json: @inventory.errors, 
                           status: :unprocessable_entity }
      end
    end
  end

  # POST /inventory_template_groups/update
  def update
    @inventory = @owner.restaurant.inventory_template_groups.find(params[:inventory_template_group][:id])

    respond_to do |format|
      if @inventory.update_attributes(params[:inventory_template_group])
        format.json { render json: @inventory, status: 200  }
      else
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
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