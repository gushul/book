class OwnerDashboardsController < ApplicationController
  before_filter :authenticate_owner!
  
  def index
  end
  
end
