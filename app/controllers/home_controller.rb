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
    Restaurant.active.offset(rnd).limit(50).each {|r| arr << r.id }
    # arr = arr.sample(3)
    arr = arr.sample(Restaurant.active.count)
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
    # @restaurant = Restaurant.new
    # arr = []
    # # when will be many restaurants need to limit records and rnd offset 
    # # rnd = rand(Restaurant.count-2)
    # rnd = rand(0)
    # Restaurant.active.offset(rnd).limit(50).each {|r| arr << r.id }
    # # arr = arr.sample(3)
    # arr = arr.sample(Restaurant.active.count)
    # arr.each {|id| @restaurants <<  Restaurant.find(id) }
    # # @restaurants = @restaurants.page(params[:page]).per(5)
    # @restaurants = Kaminari.paginate_array(@restaurants).page(params[:page]).per(5)

    @restaurants_new = Restaurant.a_new.limit(5).name_order_asc
    @restaurants_popular = Restaurant.a_popular.limit(5).name_order_asc
    @restaurants_recommended = Restaurant.a_recom.limit(5).name_order_asc

  end

  # GET /search/:search_term
  def search
    @search_terms = []
    if !params['name'].blank?
      @search_results_full = Restaurant.active.where("name like ?", "%#{params['name']}%")
      @search_results = @search_results_full.page(params[:page])
    elsif !params['filter'].blank? && !params["tags"].blank? 
      # restaurants_array = JSON.parse(params['filter'])
      restaurants_array = Restaurant.where(active: true).pluck(:id)
      restaurants_tags = params["tags"].collect { |i| i.to_i }

      restaurants = Restaurant.active.by_ids_and_tags(restaurants_array, restaurants_tags)
      @search_results_full = restaurants
      @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    # elsif !params['filter'].blank?
    #   restaurants_array = JSON.parse(params['filter'])
    #   restaurants = Restaurant.by_ids(restaurants_array)
    #   @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    else
      @search_results_full = Restaurant.active.all
      @search_results = Restaurant.active.page(params[:page])
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

  def filter_search


    if !params['filter'].blank? && !params["tags"].blank?
      restaurants_array = Restaurant.where(active: true).pluck(:id)
      restaurants_tags = params["tags"].collect { |i| i.to_i }

      restaurants = Restaurant.active.by_ids_and_tags(restaurants_array, restaurants_tags)
      @search_results_full = restaurants
      @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    else
      @search_results_full = Restaurant.active.all
      @search_results = Restaurant.active.page(params[:page])
      @search_terms << "All restaurants"
    end

    unless @search_results.blank?
      @image_tag_string = "http://maps.google.com/maps/api/staticmap?key=AIzaSyC77WBfl-zki0vS7h9zyKyYg3htKcERvuo&size=550x550"
      @search_results.each do |restaurant|
        @image_tag_string << "&markers=icon:http://i42.tinypic.com/rj2txf.png%7C#{restaurant.lat}%2C#{restaurant.lng}"
      end
      @image_tag_string << '&sensor=false'
    end

    render :layout => false
  end
  
  def search_with_date_time
    @search_terms = []

    if !params['srch-restaurant'].blank?
      if params['datepicker'].present?
        @date = Date.strptime(params['datepicker'], '%m/%d/%Y') 
        # @search_results_full = Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date)
        # @search_results =  Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date).page(params[:page])
      # else
        @search_results_full = Restaurant.active.where("name like ?", "%#{params['srch-restaurant']}%")
        @search_results = Restaurant.active.where("name like ?", "%#{params['srch-restaurant']}%").page(params[:page])
      end
    elsif !params['srch-location'].blank?
      if params['datepicker'].present?
        date = Date.strptime(params['datepicker'], '%m/%d/%Y') 
        # @search_results_full = Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date)
        # @search_results =  Restaurant.joins(:inventories).where('name like ? AND inventories.date = ?', "%#{params['srch-restaurant']}%", date).page(params[:page])
      # else
        # query1 = Restaurant.where("name like ? OR address like ?", "%#{params['srch-location']}%", "%#{params['srch-location']}%")
        query = Restaurant.active.by_location_or_cuisine("#{params['srch-location']}")
        # query2 = Restaurant.by_tag_title("#{params['srch-location']}")
        # merged_select = query1.merge(query2)
        @search_results_full = query
        @search_results = query.page(params[:page])
      end
    elsif !params['datepicker'].blank? && !params['timepicker'].blank?
      @date = Date.strptime(params['datepicker'], '%m/%d/%Y') 
      @time = Time.strptime(params['timepicker'], '%H:%M %p').to_s.slice(11..15) 
      @people = params['people'].to_i
      # TODO: availability need to check
      @search_results_full = Restaurant.active.by_date_time_people(@date, @time, @people)
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
      restaurants = Restaurant.active.by_ids_and_tags(restaurants_array, restaurants_tags)
      @search_results_full = restaurants
      @search_results = Kaminari.paginate_array(restaurants).page(params[:page])
    else
      @search_results_full = Restaurant.active.all
      @search_results = Restaurant.active.page(params[:page])
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
      date = params[:datepicker].gsub!('/','-')
      @date = date
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

  def admin
    if params[:page] == "new_owner"
      page = "admin_new_owner"
    elsif params[:page] == "new_restaurant"
      page = "admin_new_restaurant"
    else
      page = "admin_dashboard"
    end
    render page, layout: false      
  end

  def admin_owner_create
    owner = Owner.new(params[:owner])

    respond_to do |format|
      if owner.save
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "new_restaurant", :id => owner.id ), 
          notice: 'Owner was successfully created.'
           }
      else
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "new_owner"), 
          notice: "#{owner.errors.messages}"
        }
      end
    end
  end

  def admin_restaurant_create
    restaurant = Restaurant.new(params[:restaurant])

    respond_to do |format|
      if restaurant.save
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "dashboard" ), 
          notice: 'Restaurant was successfully created.'
           }
      else
        format.html { 
          redirect_to admin_path(:admin => "admin", :pass => "123", :page => "new_restaurant"), 
          notice: "#{restaurant.errors.messages}"
        }
      end
    end
  end

end   