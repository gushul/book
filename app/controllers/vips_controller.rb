# encoding: utf-8
class VipsController < ApplicationController
  before_filter :authenticate_owner!

  # POST /vips
  def create
    @vip = Vip.new
    @vip.name    = params[:user][:name]
    @vip.phone   = params[:user][:phone]
    @vip.user_id = params[:user][:user_id]
    @vip.restaurant_id = current_owner.restaurant.id

    if @vip.save
      redirect_to customers_index_owner_dashboards_url, 
                  notice: 'Vip was successfully created.' 
    else
      redirect_to customers_index_owner_dashboards_url, 
                  notice: 'error occured.' 
    end
  end

  # DELETE /vips/ (user_object)
  def destroy
    if params[:user][:user_id].present?
      @vip = Vip.where(:user_id => params[:user][:user_id]).where(:restaurant_id => current_owner.restaurant.id).first
    else
      @vip = Vip.where(:name => params[:user][:name]).where(:phone => params[:user][:phone]).where(:restaurant_id => current_owner.restaurant.id).first
    end
    @vip.destroy
    redirect_to customers_index_owner_dashboards_path 
  end

end
  