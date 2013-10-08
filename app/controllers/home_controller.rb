# encoding: utf-8
class HomeController < ApplicationController

  # root route
  def index
    @active_home = "active"
    if params[:set_locale]
      redirect_to root_path(locale: params[:set_locale])
    elsif 
  	  # @restaurant1 = Restaurant.first(:order => "RAND()")
  	  # @restaurant2 = Restaurant.last(:order => "RAND()")
      if user_signed_in?
        @rewards = current_user.rewards
      end
    end

    @restaurants = []
    arr = []
    # when will be many restaurants need to limit records and rnd offset 
    rnd = rand(Restaurant.count-2)
    Restaurant.offset(rnd).limit(50).each {|r| arr << r.id }
    arr = arr.sample(3)
    arr.each {|id| @restaurants <<  Restaurant.find(id) }

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

    unless @search["cuisine"][0].to_i == 0
      if RestaurantTag.find(@search["cuisine"][0].to_i).title == "Cuisine:Any" 
        @search["cuisine"] = "Any"
      end
    end

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


  def calendar
    
  end

end   