class OwnerMailer < ActionMailer::Base
  add_template_helper(ReservationsHelper)
  default :from => "notifications@restaurant-booking.com"

  def booking_create(reservation)
    @reservation = reservation
    mail( to: reservation.restaurant.owner.email, 
          subject: "Reservation added (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_update(reservation)
    @reservation = reservation
    mail( to: reservation.restaurant.owner.email,  
          subject: "Reservation updated (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_removed(reservation)
    @reservation = reservation
    mail( to: reservation.restaurant.owner.email,  
          subject: "Reservation deleted (#{@reservation.restaurant.name} restaurant)")
  end

end