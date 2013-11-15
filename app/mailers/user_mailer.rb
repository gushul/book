class UserMailer < ActionMailer::Base
  add_template_helper(ReservationsHelper)
  default :from => "notifications@hungryhub.com"

  def booking_create(user, reservation)
    @user = user
    @reservation = reservation
    mail( to: @user.email, 
          subject: "Reservation info (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_update(user, reservation)
    @user = user
    @reservation = reservation
    mail( to: @user.email, 
          subject: "Reservation updated (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_removed(user, reservation)
    @user = user
    @reservation = reservation
    mail( to: @user.email, 
          subject: "Reservation deleted (#{@reservation.restaurant.name} restaurant)")
  end

  def registration_confirmation(email, code)
    @code = code
    mail( to: email, 
          subject: "Your verification code")
  end

end
