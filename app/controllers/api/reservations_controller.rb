# TODO: before_filters rewiew 
class Api::ReservationsController < Api::BaseController
  skip_before_filter  :verify_authenticity_token

  before_filter :check_user_auth_params
  before_filter :check_reservations_params, only: [:create, :update]

  # POST /reservations
  def index
    @reservations = @user.reservations
    @reservations_json = []
    @reservations.each do |r|
      ro = r
      r = r.as_json
      %w{arrived email no_show owner_id}.each {|k| r.delete(k)}
      r[:start_time] = ro.start_time_format
      r[:end_time] = ro.end_time_format
      @reservations_json << r
    end

    render json: @reservations_json, status: 200 
  end

  # POST /reservations/create
  def create
    @reservation = Reservation.new(params[:reservation])

#    @reservation.date = @reservation.date+7.hour
#    @reservation.start_time = @reservation.start_time+7.hour
#    @reservation.end_time = @reservation.end_time+7.hour
		
    @reservation.user_id = @user.id
    @reservation.active = true

    restaurant = Restaurant.where(id: @reservation.restaurant_id).first
    
    @reservation.end_time = @reservation.start_time+restaurant.res_duration.minutes
    
    date = @reservation.date
    time = @reservation.start_time
    people = @reservation.party_size
    available = restaurant.check_availability_for_api(date, time, people)

    check = false
    if available == true && available.to_s.include?('ERR') == false
      check = true
    end

    p check
    p available

    respond_to do |format|
      if check && @reservation.save 
        reservation = @reservation.as_json
#        reservation[:date] = @reservation.date.utc
        reservation[:start_time]  = @reservation.start_time_format
        reservation[:end_time]    = @reservation.end_time_format
        format.json { render json: reservation, status: 200 }
      else
        format.json {
        available = "" if check
        # err1 = "ERR:#{@reservation.errors}" if @reservation.errors
#				render json: @reservation.errors, 
#				status: :unprocessable_entity
        # render text: "ERR:#{@reservation.errors.to_s}", status: 400
        p @reservation.errors
        # p @reservation.save!
				render text: "#{available}", status: 400
			}
      end
    end
  end

  # POST /reservations/update
  def update
    @reservation = Reservation.find(params[:reservation][:id])
    @reservation.user_id = @user.id

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        reservation = @reservation.as_json
        reservation[:start_time]  = @reservation.start_time_format
        reservation[:end_time]    = @reservation.end_time_format
        format.json { render json: reservation, status: 200 }
      else
        format.json { 
	
			#render json: @reservation.errors, 
			#status: :unprocessable_entity 
			render text: "ERR:#{@reservation.errors.to_s}", status: 400
			}
      end
    end
  end

private

  def check_user_auth_params
    error = false
    if params[:user].blank? or
          %w{email password}.map {|el| params[:user].has_key?(el) }.include?(false) or
          params[:user].values.any?(&:blank?)
      error   = true
      message = "ERR:Incorrect Login/Password for Action"
      status  = 403
    elsif params[:user].length > 2
      error   = true
      message = "ERR:Invalid Request"
      status  = 400
    else 
      # will be used in create and update
      @user = User.where(:email => params[:user][:email] ).first
      if @user.nil? or !@user.valid_password?(params[:user][:password])
        error   = true
        message = "ERR:Incorrect Login/Password"
        status  = 403
      end
    end

    if error
      render text: message, status: status 
    end
  end

  def check_reservations_params
      error = false
      if params[:reservation].blank? or 
            %w{restaurant_id date party_size start_time end_time active}.map {|el| params[:reservation].has_key?(el) }.include?(false) or
            params[:reservation].values.any?(&:blank?)
        error   = true
        message = "ERR:Invalid Reservation Parameters"
        status  = 400   
      # elsif params[:reservation].length > 6 or params.length > 6
      #   error   = true
      #   message = "Provide ONLY needed parameters for this action"
      #   status  = 400  
      end

      if error
        render text: message, status: status 
      end
  end 

end