class InventoryTemplatesController < ApplicationController
  before_filter :authenticate_owner!#, 
                #except: [:index, :show]
  before_filter :check_who_editing,  
                except: [:index, :show, :new, :create, :my]
   
  # GET /inventory_templates
  # GET /inventory_templates.json
  def index
    @inventory_templates = InventoryTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_templates }
    end
  end

  def my  
    @inventory_templates = current_owner.restaurant.inventory_templates
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
    @inventory_template.restaurant = current_owner.restaurant

    @intervals = []
    24.times do |h| 
      4.times do |m| 
        if h<10 and m!=0
          @intervals << "0#{h}:#{m*15}" 
        elsif h<10 and m==0
          @intervals << "0#{h}:00" 
        elsif h>=10 and m!=0
          @intervals << "#{h}:#{m*15}" 
        elsif h>=10 and m==0
          @intervals << "#{h}:0#{m*15}" 
        else
          @intervals << "#{h}:#{m*15}" 
        end
      end
    end
    @intervals << "24:00"

    @intervals.each do |interval| 
      quan = params[:inventory_template][:quantity_available]["#{@intervals.index(interval)}".to_s]
      unless interval == "24:00" or quan.to_i == 0
        @inventory_template = InventoryTemplate.new(name: params[:inventory_template][:name])
        @inventory_template.restaurant = current_owner.restaurant
        @inventory_template.primary = params[:inventory_template][:primary]
        
        @inventory_template.start_time = interval
        @inventory_template.end_time = @intervals[@intervals.index(interval)+1]
        @inventory_template.quantity_available = quan

        @inventory_template.save
      end 
    end 

    redirect_to inventory_templates_path

    # respond_to do |format|
    #   if @inventory_template.save
    #     format.html { redirect_to @inventory_template, notice: 'Inventory template was successfully created.' }
    #     format.json { render json: @inventory_template, status: :created, location: @inventory_template }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @inventory_template.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /inventory_templates/1
  # PUT /inventory_templates/1.json
  def update
    @inventory_template = InventoryTemplate.find(params[:id])
    @inventory_template.restaurant = current_owner.restaurant

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

private 

  def check_who_editing
    @inventory_template = InventoryTemplate.find(params[:id])
    unless @inventory_template.restaurant.owner == current_owner
      respond_to do |format|
        format.html { 
          redirect_to @inventory_template, 
          alert: "It's not yours inventory template!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    end
  end

end
