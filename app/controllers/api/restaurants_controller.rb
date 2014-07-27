# encoding: utf-8
class Api::RestaurantsController < Api::BaseController
  
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
    @restaurants.each do |r|
      r[:earliest_time] = r.earliest_time
      r[:latest_time]   = r.latest_time 
      r[:tags] = []
      r.restaurant_tags.each do |t|
        r[:tags] << t.title
      end
    end
    @restaurants_json = []
    @restaurants.each do |r|
#      if r.active then
        r = r.as_json
        # %w{mon tue wed thu fri sat sun 
        %w{owner_id updated_at created_at}.each {|k| r.delete(k)}
        @restaurants_json << r
#      end
    end
    render json: @restaurants_json 
  end

  # GET /restaurants/1.json
  def show
    begin
      @restaurant = Restaurant.find(params[:id])
      @restaurant[:earliest_time] = @restaurant.earliest_time
      @restaurant[:latest_time]   = @restaurant.latest_time
      @restaurant[:tags] = []
      @restaurant.restaurant_tags.each do |t|
        @restaurant[:tags] << t.title
      end
      @restaurant = @restaurant.as_json
        # %w{mon tue wed thu fri sat sun 
       %w{owner_id updated_at created_at}.each {|k| @restaurant.delete(k)}
    rescue 
      @restaurant = "{\"id\":[\"Invalid Restaurant ID\"]}"
#      render json: @restaurant, status: :unprocessable_entity
      render text: 'ERR:Invalid Restaurant ID', status: 400
      return
    end
    render json: @restaurant
  end

  def list_restaurants
    @restaurants = Restaurant.all
    @restaurants.each do |r|
      r[:earliest_time] = r.earliest_time
      r[:latest_time]   = r.latest_time 
      r[:tags] = []
      r[:star_float]=r.star_format_f
      r[:star_int]=r.star_format
      r[:price]=r.price_format
      r[:cuisines_format]=r.cuisines_format
      if r.photos.first.present? && r.cover_photos.present?
        r[:restaurant_cover_photo]=r.cover_photos.first.picture.url(:v280x160)
      elsif r.photos.first.present?
        r[:restaurant_cover_photo]=r.photos.first.picture.url(:v280x160)
      else
        r[:restaurant_cover_photo]=nil
      end 
      r.restaurant_tags.each do |t|
        r[:tags] << t.title
      end
    end
    @restaurants_json = []
    @restaurants.each do |r|
#      if r.active then
        r = r.as_json
        # %w{mon tue wed thu fri sat sun 
        %w{owner_id updated_at created_at}.each {|k| r.delete(k)}
        @restaurants_json << r
#      end
    end
    render json: @restaurants_json 
  end
    
end
