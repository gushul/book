# encoding: utf-8
class HomeController < ApplicationController
  autocomplete :restaurant, :name, :full => true#, :extra_data => [:slogan]

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
    @restaurant = Restaurant.new
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
    if !params['name'].blank?
      @search_results_full = Restaurant.where("name like ?", "%#{params['name']}%")
      @search_results = @search_results_full.page(params[:page])
    elsif !params['filter'].blank? && !params["tags"].blank? 
      restaurants_array = JSON.parse(params['filter'])
      restaurants_tags = params["tags"].collect { |i| i.to_i }
      restaurants = Restaurant.by_ids_and_tags(restaurants_array, restaurants_tags)
      @search_results_full = restaurants
      @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    # elsif !params['filter'].blank?
    #   restaurants_array = JSON.parse(params['filter'])
    #   restaurants = Restaurant.by_ids(restaurants_array)
    #   @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    else
      @search_results_full = Restaurant.all
      @search_results = Restaurant.page(params[:page])
      @search_terms << "All restaurants"
    end

    unless @search_results.blank?
      @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x550"
      @search_results.each do |restaurant|
        @image_tag_string << "&markers=icon:http://i42.tinypic.com/rj2txf.png%7C#{restaurant.lat}%2C#{restaurant.lng}"
      end
      @image_tag_string << '&sensor=false'
    end
  end
  
  def search_with_date_time
    @search_terms = []

    if !params['srch-restaurant'].blank?
      if params['datepicker'].present?
        date = Date.strptime(params['datepicker'], '%m/%d/%Y') 
        @search_results_full = Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date)
        @search_results =  Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date).page(params[:page])
      else
        @search_results_full = Restaurant.where("name like ?", "%#{params['srch-restaurant']}%")
        @search_results = Restaurant.where("name like ?", "%#{params['srch-restaurant']}%").page(params[:page])
      end
    elsif !params['datepicker'].blank? && !params['timepicker'].blank?
      @date = Date.strptime(params['datepicker'], '%m/%d/%Y') 
      @time = Time.strptime(params['timepicker'], '%H:%M %p').to_s.slice(11..15) 
      @people = params['people'].to_i
      # TODO: availability need to check
      @search_results_full = Restaurant.by_date_time_people(@date, @time, @people)
      @inventories = []
      @search_results_full.each do |r|
        arr = []
        Inventory.find_available_time(@date, @time, @people, r.id ).each do |inv|
          arr << inv.start_time.to_s.slice(11..15) 
        end
        @inventories << arr
      end
      @search_results =  @search_results_full.page(params[:page])
    elsif !params['filter'].blank? && !params["tags"].blank? 
      restaurants_array = JSON.parse(params['filter'])
      restaurants_tags = params["tags"].collect { |i| i.to_i }
      restaurants = Restaurant.by_ids_and_tags(restaurants_array, restaurants_tags)
      @search_results_full = restaurants
      @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    else
      @search_results_full = Restaurant.all
      @search_results = Restaurant.page(params[:page])
      @search_terms << "All restaurants"
    end

    unless @search_results.blank?
      @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x550"
      @search_results.each do |restaurant|
        @image_tag_string << "&markers=icon:http://i42.tinypic.com/rj2txf.png%7C#{restaurant.lat}%2C#{restaurant.lng}"
      end
      @image_tag_string << '&sensor=false'
    end
    
  end

  def check_availability
    if current_user.present? || current_owner.present? 
      @restaurant = Restaurant.find(params[:restaurant_id])
      date = params[:datepicker]
      time = params[:timepicker]
      people = params[:people]
      # available = false
      available = @restaurant.check_availability(date, time, people)
      r_path = book_restaurant_path(:id => @restaurant.id, 
        :datepicker => date, 
        :timepicker => time, 
        :people => people,
        :status => available.to_s)
      mes = false
    else
      r_path = new_user_registration_path
      mes = "Please, register first."
    end
      redirect_to r_path, notice: mes
  end
  
  def about_us
  end

end   