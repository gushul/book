class UserDashboardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @stats = []
    reservations = current_user.reservations.where('created_at >= ?', 90.days.ago)
    restaurants = reservations.map { |r| r.restaurant }.uniq
    restaurants.each_with_index do |rst, i|
      res = reservations.where(restaurant_id: rst)
      rew = res.map { |r| r.reward }.compact.map(&:points_total).reduce(0, :+)
      @stats[i] = []
      @stats[i] << rst.name
      @stats[i] << rew
      @stats[i] << res.count
    end

  end
  
  def reservations
    @reservations = current_user.reservations.order("reservations.created_at DESC")
  end

  def rewards
    @rewards = current_user.rewards.order("rewards.created_at DESC")
  end

end