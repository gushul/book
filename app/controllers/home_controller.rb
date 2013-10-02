class HomeController < ApplicationController

  # root route
  def index
	  # @restaurant1 = Restaurant.first(:order => "RAND()")
	  # @restaurant2 = Restaurant.last(:order => "RAND()")
    if user_signed_in?
      @rewards = current_user.rewards
    end
  end

  # GET /search/:search_term
  # todo: refactor
  def search
    @search = Hash.new
    @search["cuisine"]  = "Any" unless params[:cuisine].present?
    @search["price"]    = "Any" unless params[:price].present?
    @search["location"] = "Any" unless params[:location].present?
    @search["cuisine"]  ||= params[:cuisine]
    @search["price"]    ||= params[:price]
    @search["location"] ||= params[:location]

    if @search["cuisine"].class == Array
      @search["cuisine"].map! {|c| c=RestaurantTag.find(c).title} 
    else
      @search["cuisine"] = ["Any"]
    end

    if @search["price"][0]!="Any" and 
          @search["cuisine"][0]!="Any" 
      # @restaurants = Restaurant.near(@search, 10).limit(10)
      @search_results = Restaurant.with_cuisine(@search["cuisine"]).with_price(@search["price"])
    elsif @search["cuisine"][0]=="Any" and 
            @search["price"][0]!="Any" 
      @search_results = Restaurant.with_price(@search["price"])
    elsif @search["cuisine"][0]!="Any" and 
            @search["price"][0]=="Any" 
      @search_results = Restaurant.with_cuisine(@search["cuisine"])
    else 
      @search_results = Restaurant.all
    end

    unless @search_results.blank?
      @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x300"
      @search_results.each do |restaurant|
        @image_tag_string << "&markers=icon:http://tinyurl.com/pgdsbxb%7C#{restaurant.lat}%2C#{restaurant.lng}"
      end
      @image_tag_string << '&sensor=false'
    end


  end

end   