class OwnerMailer < ActionMailer::Base
  include Resque::Mailer
  add_template_helper(ReservationsHelper)
  default :from => "no-reply@hungryhub.com"

  def booking_create(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @reservation.restaurant.owner.email, 
          subject: "Reservation added (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_update(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @reservation.restaurant.owner.email,  
          subject: "Reservation updated (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_removed(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @reservation.restaurant.owner.email,  
          subject: "Reservation deleted (#{@reservation.restaurant.name} restaurant)")
  end
  
  def booking_cancel(reservation_id,email)
    @reservation = Reservation.find(reservation_id)
#    mail( to: @reservation.restaurant.owner.email, cc: email,  
#          subject: "Reservation Canceled (#{@reservation.restaurant.name} restaurant)")
    mail( to: @reservation.restaurant.owner.email, 
          subject: "Reservation Canceled (#{@reservation.restaurant.name} restaurant)")
  end
  
  def booking_special_request(reservation_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @reservation.restaurant.owner.email, 
          subject: "UPDATED Special Request (#{@reservation.restaurant.name} restaurant)")
  end

end