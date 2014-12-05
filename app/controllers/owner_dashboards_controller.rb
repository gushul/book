class OwnerDashboardsController < ApplicationController
  before_filter :authenticate_owner!
  
  def index
    if current_owner.restaurant.present?
      res = current_owner.restaurant.reservations
      @res_today = res.today
      @res_yesterday = res.yesterday
      @res_next_7_days = res.next_7_days

      @res_manual = res.created_today.manualy_created
      @res_normal = res.exc_owners.created_today.user_created
    end
  end
  
  def customers
#    @owners = current_owner.restaurant.reservations.active.where("name <> ?", "")
#    @owners = current_owner.restaurant.reservations.active.where("user_id IS NULL", "")
#    @users  = current_owner.restaurant.reservations.active.map {|res| res.user }.uniq
    @owners = current_owner.restaurant.reservations.where("user_id IS NULL", "")
    @users  = current_owner.restaurant.reservations.map {|res| res.user }.uniq

    @info_json = []
    @users.each do |r|
      info = {}
      if r.present?
        info[:name]    = r[:username]
        info[:email]   = r[:email]
        info[:phone]   = r[:phone]
        info[:user_id] = r[:id]
        if r.vips.map {|v| v.restaurant_id == current_owner.restaurant.id }.include?(true)
          info[:vip] = true
        else
          info[:vip] = false
        end
        res = current_owner.restaurant.reservations.active.where(user_id: r[:id])
        info[:total_visit] = res.count
        if !res.last.nil? then
          info[:last_visit] = res.last.date
        else
          info[:last_visit] = nil
        end
        @info_json << info
      end
    end

    @owners.each do |r|
      info = {}
      info[:name]  = r[:name]
      info[:phone] = r[:phone]
      info[:email] = r[:email]
      if Vip.where(:name => info[:name]).where(:phone => info[:phone]).where(:restaurant_id => current_owner.restaurant.id).first.present?
        info[:vip] = true
      else
        info[:vip] = false
      end
      res = current_owner.restaurant.reservations.active.where(email: r[:email])
      info[:total_visit] = res.count
      info[:last_visit] = res.last.date if res.present?
      @info_json << info
    end


  end

  def reservations
    if current_owner.restaurant.blank?
      @reservations = []
    else
      @reservations = current_owner.restaurant.reservations
      if params[:date].present? 
        if ['today','yesterday','next_7_days'].any? { |word| params[:date].include?(word) }
          @reservations = @reservations.send(params[:date])
        else
          @date = Date.strptime(params[:date], '%d-%m-%Y')
          @reservations = @reservations.by_date(@date)
        end
      else
        @reservations = @reservations.today
      end
      @reservations_pending = [] # @reservations.first(3) # STUB
      @reservations_confirm = [] # @reservations.last(1)  # STUB
    end
  end

  def reservation
    render 'owner_dashboards/reservations/form'
  end

  def rewards
  end

  def reports
    @res =  current_owner.restaurant.reservations.by_month_year( params[:date] )
    @completed = @res.completed
    @no_show = @res.no_show
    @cancel = @res.cancel
    @pending = @res.pending
  end

  def inventories
    if params[:date].present? 
      @date = Date.strptime(params[:date], '%d-%m-%Y').strftime('%Y-%m-%d')
    else
      @date = Time.zone.today.strftime('%Y-%m-%d')
    end
    @inventories = current_owner.restaurant.inventories.by_date(@date)
  end

  def inventory
    @inventory = current_owner.restaurant.inventories.find(params[:id])
    render 'owner_dashboards/inventories/show'
  end

  def account
  end

  def remake_inventory
    if params[:restaurant].present?
      res_id = params[:restaurant]
      Restaurant.find(res_id).inventories.delete_all
      Restaurant.generate_schedule(res_id)  
    end
    redirect_to inventories_owner_dashboards_path, notice: "Inventories updated"
  end

end
