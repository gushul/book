class InventoryTemplatesController < ApplicationController
  before_filter :authenticate_owner!, 
                except: [:index, :show]
   
  # GET /inventory_templates
  # GET /inventory_templates.json
  def index
    @inventory_templates = InventoryTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_templates }
    end
  end
  
  # GET /inventory_templates/1
  # GET /inventory_templates/1.json
  def show
    @inventory_template = InventoryTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_template }
    end
  end

  # GET /inventory_templates/new
  # GET /inventory_templates/new.json
  def new
    @inventory_template = InventoryTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_template }
    end
  end

  # GET /inventory_templates/1/edit
  def edit
    @inventory_template = InventoryTemplate.find(params[:id])
  end

  # POST /inventory_templates
  # POST /inventory_templates.json
  def create
    @inventory_template = InventoryTemplate.new(params[:inventory_template])

    respond_to do |format|
      if @inventory_template.save
        format.html { redirect_to @inventory_template, notice: 'Inventory template was successfully created.' }
        format.json { render json: @inventory_template, status: :created, location: @inventory_template }
      else
        format.html { render action: "new" }
        format.json { render json: @inventory_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inventory_templates/1
  # PUT /inventory_templates/1.json
  def update
    @inventory_template = InventoryTemplate.find(params[:id])

    respond_to do |format|
      if @inventory_template.update_attributes(params[:inventory_template])
        format.html { redirect_to @inventory_template, notice: 'Inventory template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_templates/1
  # DELETE /inventory_templates/1.json
  def destroy
    @inventory_template = InventoryTemplate.find(params[:id])
    @inventory_template.destroy

    respond_to do |format|
      format.html { redirect_to inventory_templates_url }
      format.json { head :no_content }
    end
  end 

end
