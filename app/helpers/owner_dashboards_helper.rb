module OwnerDashboardsHelper
  def show_source(reservation)
    if reservation.user_id
      'Hungry hub'
    else
      'Manual'
    end
  end
end