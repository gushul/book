# encoding: utf-8
class HomeController < ApplicationController

  def landing
    @home = true
    @restaurants = []
    arr = []
    # when will be many restaurants need to limit records and rnd offset 
    # rnd = rand(Restaurant.count-2)
    rnd = rand(0)
    Restaurant.offset(rnd).limit(50).each {|r| arr << r.id }
    # arr = arr.sample(3)
    arr = arr.sample(Restaurant.count)
    arr.each {|id| @restaurants <<  Restaurant.find(id) }
  end

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
    # rnd = rand(Restaurant.count-2)
    rnd = rand(0)
    Restaurant.offset(rnd).limit(50).each {|r| arr << r.id }
    # arr = arr.sample(3)
    arr = arr.sample(Restaurant.count)
    arr.each {|id| @restaurants <<  Restaurant.find(id) }

  end

  # GET /search/:search_term
  
  def search
    @search_terms = []
    unless params['srch-term'].blank?
      @search_results = Restaurant.where("name like ?", "%#{params['srch-term']}%").page(params[:page])
    else
      @search_results = Restaurant.page(params[:page])
      @search_terms << "All restaurants"
    end

    unless @search_results.blank?
      @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x300"
      @search_results.each do |restaurant|
        @image_tag_string << "&markers=icon:http://tinyurl.com/pgdsbxb%7C#{restaurant.lat}%2C#{restaurant.lng}"
      end
      @image_tag_string << '&sensor=false'
    end
  end
  
  def search_with_date_time
    @search_terms = []

    unless params['srch-restaurant'].blank?
      if params['datepicker'].present?
        date = Date.strptime(params['datepicker'], '%m/%d/%Y') 
        @search_results =  Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date).page(params[:page])
      else
        @search_results = Restaurant.where("name like ?", "%#{params['srch-restaurant']}%").page(params[:page])
      end
    else
      @search_results = Restaurant.all
      @search_terms << "All restaurants"
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