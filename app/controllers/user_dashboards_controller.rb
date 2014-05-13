class UserDashboardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    # @reservations = current_user.reservations
  end
  
  def reservations
    @reservations = current_user.reservations
  end

  def rewards
    @rewards = current_user.rewards
  end

end