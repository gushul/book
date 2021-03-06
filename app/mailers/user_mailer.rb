class UserMailer < ActionMailer::Base
  include Resque::Mailer
  add_template_helper(ReservationsHelper)
  default :from => "no-reply@hungryhub.com"

  def booking_create(user_id, reservation_id)
    @user = User.find(user_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @user.email,  cc: 'support@hungryhub.com',
          subject: "Your Reservation Confirmation at #{@reservation.restaurant.name}")
  end

  def booking_thank_you(user_id, reservation_id)
    @user = User.find(user_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @user.email,  cc: 'support@hungryhub.com',
          subject: "Share your experience at #{@reservation.restaurant.name}")
  end
  
  def booking_create_no_ack(user_id, reservation_id)
    @user = User.find(user_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @user.email,  cc: 'support@hungryhub.com',
          subject: "Your Reservation is Pending Confirmation at #{@reservation.restaurant.name}")
  end

  def booking_update(user_id, reservation_id)
    @user = User.find(user_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @user.email, 
          subject: "Reservation updated (#{@reservation.restaurant.name} restaurant)")
  end

  def booking_removed(user_id, reservation_id)
    @user = User.find(user_id)
    @reservation = Reservation.find(reservation_id)
    mail( to: @user.email, 
          subject: "Reservation deleted (#{@reservation.restaurant.name} restaurant)")
  end

  def registration_confirmation(email, code, username)
    @code = code
    @username = username
    mail( to: email, 
          subject: "Welcome to Hungry Hub")
  end

end
