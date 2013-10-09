# encoding: utf-8
class Api::RestaurantsController < ApplicationController
  
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
    render json: @restaurants 
  end

  # GET /restaurants/1.json
  def show
    @restaurant = Restaurant.find(params[:id])
    render json: @restaurant
  end
    
end
