# encoding: utf-8
class RestaurantsController < ApplicationController
  before_filter :authenticate_owner!, 
                except: [:index, :index_all, :show, :list_restaurants]

  # GET /restaurants
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
    # @restaurants = current_owner.restaurants

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @restaurants }
    end
  end

  # GET /restaurants_all
  def index_all
    @search_results_full = Restaurant.active.all
    @search_results = Restaurant.active.name_order_asc.page(params[:page])

    unless @search_results.blank?
      @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x550"
      @search_results.each do |restaurant|
        @image_tag_string << "&markers=icon:http://i42.tinypic.com/rj2txf.png%7C#{restaurant.lat}%2C#{restaurant.lng}"
      end
      @image_tag_string << '&sensor=false'
    end

  end
     
  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    @restaurant = Restaurant.find(params[:id])
    @reservation = Reservation.new
    @image_tag_string = "/assets/slideshow-rest.jpg"

    @google_map = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=400x300"
    @google_map << "&markers=icon:http://i42.tinypic.com/rj2txf.png%7C#{@restaurant.lat}%2C#{@restaurant.lng}"
    @google_map << '&sensor=false&zoom=16'

    @today = true
    if @restaurant.inventories.available.size >= 3
      @times = @restaurant.inventories.available.limit(3).map{|inv| inv.start_time.to_s.slice(11..15)}
    else
      @today = false
      @times = @restaurant.inventories.available((Time.zone.today + 1.day), "00:00").limit(3).map{|inv| inv.start_time.to_s.slice(11..15)}
    end

    @times = ["18:30","19:00","19:30"]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @restaurant }
    end
  end
     
  # GET /restaurants/new
  # GET /restaurants/new.json
  def new
    @restaurant = Restaurant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @restaurant }
    end
  end

  # GET /restaurants/1/edit
  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(params[:restaurant])
    @restaurant.owner_id = current_owner.id

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render json: @restaurant, status: :created, location: @restaurant }
      else
        format.html { render action: "new" }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /restaurants/1
  # PUT /restaurants/1.json
  def update 
    @restaurant = Restaurant.find(params[:id])
    @restaurant.owner_id = current_owner.id

    p '0----------------------------'
    p @restaurant.errors

    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        # format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.html { redirect_to account_owner_dashboards_path, notice: 'Restaurant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def list_restaurants

  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy

    respond_to do |format|
      format.html { redirect_to restaurants_url }
      format.json { head :no_content }
    end
  end
end
