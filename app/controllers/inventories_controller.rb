# encoding: utf-8
class InventoriesController < ApplicationController
  before_filter :authenticate_owner!#, 
                #except: [:index, :show]
  before_filter :check_who_editing,  
                except: [:index, :show, :new, :create, :my]

  # GET /inventories
  # GET /inventories.json
  def index  
    # @inventories = Inventory.order("id desc").page(params[:page])
    # @inventories = current_owner.restaurant.inventories.order("id desc").page(params[:page])
    @date = params[:date] ? Date.strptime(params[:date], '%m/%d/%Y') : Time.zone.today
    @inventories = current_owner.restaurant.inventories.by_date(@date).order("id desc").page(params[:page])

    @inventories1 = current_owner.restaurant.inventories.by_min_and_date("00", @date)
    @inventories2 = current_owner.restaurant.inventories.by_min_and_date("15", @date)
    @inventories3 = current_owner.restaurant.inventories.by_min_and_date("30", @date)
    @inventories4 = current_owner.restaurant.inventories.by_min_and_date("45", @date)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventories }
    end
  end

  def my  
    @inventories = current_owner.restaurant.inventories
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
    @inventory = Inventory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js 
      format.json { render json: @inventory }
    end
  end

  # GET /inventories/new
  # GET /inventories/new.json
  def new
    @inventory = Inventory.new

    respond_to do |format|
      format.html # new.html.erb
      format.js # new.html.erb
      format.json { render json: @inventory }
    end
  end

  # GET /inventories/1/edit
  def edit
    @inventory = Inventory.find(params[:id])
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.new(params[:inventory])
    @inventory.restaurant = current_owner.restaurant
    @inventory.end_time = @inventory.start_time + 15.minutes

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventory was successfully created.' }
        format.json { render json: @inventory, status: :created, location: @inventory }
      else
        format.html { render action: "new" }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end   

  # PUT /inventories/1
  # PUT /inventories/1.json
  def update
    @inventory = Inventory.find(params[:id])
    @inventory.restaurant = current_owner.restaurant
    if params[:inventory]["end_time(5i)"].present?
      params[:inventory]["end_time(5i)"] = (params[:inventory]["start_time(5i)"].to_i + 15).to_s
      params[:inventory]["end_time(4i)"] = (params[:inventory]["start_time(4i)"].to_i).to_s
      if params[:inventory]["end_time(5i)"].to_i == 60
        params[:inventory]["end_time(4i)"] = (params[:inventory]["start_time(4i)"].to_i + 1).to_s
        params[:inventory]["end_time(5i)"] = "00" 
      end
    end
    
    respond_to do |format|
      if @inventory.update_attributes(params[:inventory])
        # format.html { redirect_to @inventory, notice: 'Inventory was successfully updated.' }
        format.html { redirect_to inventories_owner_dashboards_path, notice: 'Inventory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory = Inventory.find(params[:id])
    @inventory.destroy

    respond_to do |format|
      # format.js   { redirect_to inventories_url }
      format.html { redirect_to(:back) } #redirect_to inventories_url }
      format.json { head :no_content }
    end
  end

private 

  def check_who_editing
    @inventory = Inventory.find(params[:id])
    unless @inventory.restaurant.owner == current_owner
      respond_to do |format|
        format.html { 
          redirect_to @inventory, 
          alert: "It's not yours inventory!" }
        format.json { head :no_content, 
          status: :unprocessable_entity  }
      end
    end
  end

end
