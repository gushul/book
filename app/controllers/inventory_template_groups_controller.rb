# encoding: utf-8
class InventoryTemplateGroupsController < ApplicationController
  before_filter :authenticate_owner!
  before_filter :check_who_editing,  
                except: [:index, :show, :new, :create, :my]
   
  # GET /inventory_template_groups
  # GET /inventory_template_groups.json
  def index
    # @inventory_template_groups = InventoryTemplateGroup.all
    @inventory_template_groups = current_owner.restaurant.inventory_template_groups.page(params[:page])

    @quantity = current_owner.restaurant.it_quantities

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_template_groups }
    end
  end

  def my
  end
  
  # GET /inventory_template_groups/1
  # GET /inventory_template_groups/1.json
  def show
    @inventory_template_group = InventoryTemplateGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_template_group }
    end
  end

  # GET /inventory_template_groups/new
  # GET /inventory_template_groups/new.json
  def new
    @inventory_template_group = InventoryTemplateGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_template_group }
    end
  end

  # GET /inventory_template_groups/1/edit
  def edit
    @inventory_template_group = InventoryTemplateGroup.find(params[:id])
  end

  # POST /inventory_template_groups
  # POST /inventory_template_groups.json
  def create
    @inventory_template_group = InventoryTemplateGroup.new(params[:inventory_template_group])
    @inventory_template_group.restaurant = current_owner.restaurant

    respond_to do |format|
      if @inventory_template_group.save
        format.html { redirect_to @inventory_template_group, notice: 'Inventory Template Group was successfully created.' }
        format.json { render json: @inventory_template_group, status: :created, location: @inventory_template_group }
      else
        format.html { render action: "new" }
        format.json { render json: @inventory_template_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inventory_template_groups/1
  # PUT /inventory_template_groups/1.json
  def update
    @inventory_template_group = InventoryTemplateGroup.find(params[:id])
    @inventory_template_group.restaurant = current_owner.restaurant

    respond_to do |format|
      if @inventory_template_group.update_attributes(params[:inventory_template_group])
        format.html { redirect_to @inventory_template_group, notice: 'Inventory template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory_template_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_template_groups/1
  # DELETE /inventory_template_groups/1.json
  def destroy
    @inventory_template_group = InventoryTemplateGroup.find(params[:id])
    @inventory_template_group.destroy

    respond_to do |format|
      format.html { redirect_to inventory_template_groups_url }
      format.json { head :no_content }
    end
  end 

private 

  def check_who_editing
    @inventory_template_group = InventoryTemplateGroup.find(params[:id])
    unless @inventory_template_group.restaurant.owner == current_owner
      respond_to do |format|
        format.html { 
          redirect_to @inventory_template_group, 
          alert: "It's not yours inventory template group!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    end
  end

end
