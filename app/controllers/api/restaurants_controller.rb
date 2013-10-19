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
    render json: @restaurants 
  end

  # GET /restaurants/1.json
  def show
    @restaurant = Restaurant.find(params[:id])
    @restaurant[:tags] = []
    @restaurant.restaurant_tags.each do |t|
      @restaurant[:tags] << t.title
    end
    render json: @restaurant
  end
    
end
