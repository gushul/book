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

    # @quantity = current_owner.restaurant.it_quantities
    @inventory_templates1 = current_owner.restaurant.inventory_template_groups.map {|itg| itg.inventory_templates.by_min("00")}.flatten
    @inventory_templates2 = current_owner.restaurant.inventory_template_groups.map {|itg| itg.inventory_templates.by_min("15")}.flatten
    @inventory_templates3 = current_owner.restaurant.inventory_template_groups.map {|itg| itg.inventory_templates.by_min("30")}.flatten
    @inventory_templates4 = current_owner.restaurant.inventory_template_groups.map {|itg| itg.inventory_templates.by_min("45")}.flatten

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

    @itg1 = @inventory_template_group.inventory_templates.by_min("00").flatten
    @itg2 = @inventory_template_group.inventory_templates.by_min("15").flatten
    @itg3 = @inventory_template_group.inventory_templates.by_min("30").flatten
    @itg4 = @inventory_template_group.inventory_templates.by_min("45").flatten
  end

  # POST /inventory_template_groups
  # POST /inventory_template_groups.json
  def create
    @inventory_template_group = InventoryTemplateGroup.new(params[:inventory_template_group])
    @inventory_template_group.restaurant = current_owner.restaurant

    respond_to do |format|
      if @inventory_template_group.save

        @intervals = Reservation::PERIODS
        @intervals.each do |interval| 
          quan = params[:inventory_template_group][:quantity_available]["#{@intervals.index(interval)}".to_s]
          unless interval == "24:00" or quan.to_i == 0
            @inventory_template = InventoryTemplate.new(inventory_template_group_id: @inventory_template_group.id)
            @inventory_template.start_time = interval
            @inventory_template.end_time = @intervals[@intervals.index(interval)+1]
            @inventory_template.quantity_available = quan
            @inventory_template.save
          end 
        end 
        
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
        
        @intervals = Reservation::PERIODS
        @intervals.each do |interval| 
          quan = params[:inventory_template_group][:quantity_available]["#{@intervals.index(interval)}".to_s]
          unless interval == "24:00" or quan.to_i == 0
            @inventory_template = InventoryTemplate.where(inventory_template_group_id: @inventory_template_group.id).by_time(interval).first
            if @inventory_template.blank?
              @inventory_template = InventoryTemplate.new(inventory_template_group_id: @inventory_template_group.id)
              @inventory_template.start_time = interval
              @inventory_template.end_time = @intervals[@intervals.index(interval)+1]
            end
            @inventory_template.quantity_available = quan
            @inventory_template.save
          end 
        end 

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
