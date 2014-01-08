class OwnerDashboardsController < ApplicationController
  before_filter :authenticate_owner!
  
  def index
  end
  
  def customers_index
    @owners = current_owner.restaurant.reservations.where("name <> ?", "")
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
        @info_json << info
      end
    end

    @owners.each do |r|
      info = {}
      info[:name]  = r[:name]
      info[:phone] = r[:phone]
      info[:email] = r[:email]
      @info_json << info
    end

  end


end
