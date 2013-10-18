# encoding: utf-8
class RestaurantsController < ApplicationController
  before_filter :authenticate_owner!, 
                except: [:index, :show]
  
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

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    @restaurant = Restaurant.find(params[:id])
    @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x300"
    # @image_tag_string << "&center=#{@restaurant.lat}%2C#{@restaurant.lng}"
    # @image_tag_string << "&markers=icon:http://tinyurl.com/o39bbb3%7C#{@restaurant.lat}%2C#{@restaurant.lng}"
    # @image_tag_string << "&markers=icon:http://tinyurl.com/oyoepzu%7C#{@restaurant.lat}%2C#{@restaurant.lng}"
    @image_tag_string << "&markers=icon:http://tinyurl.com/pgdsbxb%7C#{@restaurant.lat}%2C#{@restaurant.lng}"
    @image_tag_string << '&sensor=false&zoom=15'

    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @quantity = []
    4.times {|i| @quantity[i] = []}
    @restaurant.inventories.each do |inv|
      if inv.date == @date
        m1 = inv.start_time.strftime("%M").to_i
        m1 == 0 ? 0 : m1 = m1/15
        m2 = inv.end_time.strftime("%M").to_i
        m2 == 0 ? 0 : m2 = m2/15
        h1 = inv.start_time.strftime("%H").to_i
        h2 = inv.end_time.strftime("%H").to_i
        if h1 == h2 and (m2 - m1) > 0
          (m2 - m1).times {|t| @quantity[m1+t][h1] = inv.quantity_available }
        elsif h1 != h2
          (h2 - h1 + 1).times do |th| 
            unless th == h2 - h1
              4.times {|tm| @quantity[m1 + tm][h1 + th] = inv.quantity_available }
            else
              (m2 - m1).times {|tm| @quantity[m1 + tm][h1 + th] = inv.quantity_available }
            end
          end
        end
      end
    end

    @restaurant.reservations.active.each do |r|
      if r.date == @date
        m1 = r.start_time.strftime("%M").to_i
        m1 == 0 ? 0 : m1 = m1/15
        m2 = r.end_time.strftime("%M").to_i
        m2 == 0 ? 0 : m2 = m2/15
        h1 = r.start_time.strftime("%H").to_i
        h2 = r.end_time.strftime("%H").to_i
        if h1 == h2 and (m2 - m1) > 0
          (m2 - m1).times {|t| @quantity[m1+t][h1] -= r.party_size }
        elsif h1 != h2 and m1 == 0
          (h2 - h1 + 1).times do |th| 
            unless th == h2 - h1
              4.times {|tm| @quantity[m1 + tm][h1 + th] -= r.party_size }
            else
              (m2 - m1).times {|tm| @quantity[m1 + tm][h1 + th] -= r.party_size }
            end
          end
        elsif h1 != h2 and m1 > 0
          (h2 - h1 + 1).times do |th| 
            if th == 0
              (m1..3).each {|tm| @quantity[tm][h1 + th] -= r.party_size }
            elsif th > 0 and th < (h2 - h1)
              (0..3).each {|tm| @quantity[tm][h1 + th] -= r.party_size }
            else
              (0..m2-1).each {|tm| @quantity[tm][h1 + th] -= r.party_size }
            end
          end
        end
      end
    end

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



    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
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
