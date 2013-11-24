# encoding: utf-8
class Api::RestaurantsController < ApplicationController
  
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
    @restaurants.each do |r| 
      r[:tags] = []
      r.restaurant_tags.each do |t|
        r[:tags] << t.title
      end

    end
    @restaurants_json = []
    @restaurants.each do |r|
      r = r.as_json
      %w{mon tue wed thu fri sat sun 
         owner_id updated_at created_at}.each {|k| r.delete(k)}
      @restaurants_json << r
    end
    render json: @restaurants_json 
  end

  # GET /restaurants/1.json
  def show
    begin
      @restaurant = Restaurant.find(params[:id])
      @restaurant[:tags] = []
      @restaurant.restaurant_tags.each do |t|
        @restaurant[:tags] << t.title
      end
      @restaurant = @restaurant.as_json
        %w{mon tue wed thu fri sat sun 
           owner_id updated_at created_at}.each {|k| @restaurant.delete(k)}
    rescue 
      @restaurant = "{\"id\":[\"Invalid Restaurant ID\"]}"
      render json: @restaurant, status: :unprocessable_entity
      return
    end
    render json: @restaurant
  end
    
end
