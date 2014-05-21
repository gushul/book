class UserDashboardsController < ApplicationController
  
  before_filter :authenticate_user!

  def index
    @stats  = []
    @visits = 0
    reservations = current_user.reservations.active.where('created_at >= ?', 90.days.ago)
    restaurants = reservations.map { |r| r.restaurant }.uniq
    restaurants.each_with_index do |rst, i|
      res = reservations.where(restaurant_id: rst)
      rew = res.map { |r| r.reward }.compact.map(&:points_total).reduce(0, :+)
      @stats[i] = []
      @stats[i] << rst.name
      @stats[i] << rew
      @stats[i] << res.count
      @visits += res.count
    end
    @stats.sort! { |x, y| y[2] <=> x[2] }
  end
  
  def reservations
    res = current_user.reservations
    @reservations_upcoming = res.upcoming.order("reservations.date ASC, reservations.start_time ASC")
    @reservations_past = res.past.order("reservations.date DESC")
  end

  def rewards
    rewards = current_user.rewards.order("rewards.created_at DESC")
    @rewards_redeemed =  rewards.redeemed
    @rewards_received =  rewards.received
  end

end