class OwnerDashboardsController < ApplicationController
  before_filter :authenticate_owner!
  
  def index
    res = current_owner.restaurant.reservations.active
    @res_today = res.today
    @res_yesterday = res.yesterday
    @res_next_7_days = res.next_7_days

    @res_manual = res.owners
    @res_normal = res.exc_owners
  end
  
  def customers
    @owners = current_owner.restaurant.reservations.where("name <> ?", "")
    @users  = current_owner.restaurant.reservations.active.map {|res| res.user }.uniq

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
        info[:last_visit] = res.last.date
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
      @info_json << info
    end


  end

  def reservations
   if current_owner.restaurant.blank?
      @reservations = []
    else
      @reservations = current_owner.restaurant.reservations
      @reservations_pending = @reservations.first(3) # STUB
      @reservations_confirm = @reservations.last(1)  # STUB
    end
  end

  def rewards
  end

  def reports
  end

  def inventories
  end

  def account
  end

end
