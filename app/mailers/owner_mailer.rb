class OwnerMailer < ActionMailer::Base
  include Resque::Mailer
  add_template_helper(ReservationsHelper)
  default :from => "no-reply@hungryhub.com"

  def booking_create(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: reservation.restaurant.owner.email, 
          subject: "Reservation added (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_update(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: reservation.restaurant.owner.email,  
          subject: "Reservation updated (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_removed(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: reservation.restaurant.owner.email,  
          subject: "Reservation deleted (#{@reservation.restaurant.name} restaurant)")
  end

end