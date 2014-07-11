# encoding: utf-8
class Reservation < ActiveRecord::Base
  paginates_per 20

  PERIODS = ["00:00","00:15","00:30","00:45","01:00","01:15","01:30","01:45","02:00","02:15","02:30","02:45","03:00","03:15","03:30","03:45","04:00","04:15","04:30","04:45","05:00","05:15","05:30","05:45","06:00","06:15","06:30","06:45","07:00","07:15","07:30","07:45","08:00","08:15","08:30","08:45","09:00","09:15","09:30","09:45","10:00","10:15","10:30","10:45","11:00","11:15","11:30","11:45","12:00","12:15","12:30","12:45","13:00","13:15","13:30","13:45","14:00","14:15","14:30","14:45","15:00","15:15","15:30","15:45","16:00","16:15","16:30","16:45","17:00","17:15","17:30","17:45","18:00","18:15","18:30","18:45","19:00","19:15","19:30","19:45","20:00","20:15","20:30","20:45","21:00","21:15","21:30","21:45","22:00","22:15","22:30","22:45","23:00","23:15","23:30","23:45","24:00"]
 
  attr_accessible :active, :date, :party_size, 
                  :start_time, :end_time,
                  :user_id, :owner_id, :restaurant_id,
                  :name, :email, :phone,
                  :no_show, :arrived, :table,
                  :special_request,
                  :channel
 
  validates_uniqueness_of :created_at, scope: [:user_id, :owner_id]
  # validates :user_id,       :presence => true
  # validates user/owner id presence
  validates :restaurant_id, :presence => true
  validates :date,          :presence => true
  validates :start_time,    :presence => true
  validates :end_time,      :presence => true
  validates :party_size,    :presence => true

  validate  :unreg_user_validation            
  validate  :start_end_time
  validate  :restaurant_id_validation            
  # validate  :date_validation, :if => :is_restaurant_id_real?
  # validate  :party_size_available_validation

  validates :party_size, :numericality => { :greater_than => 0 }
  validates_inclusion_of :channel, :in => ChannelType

  enumerate :channel, :with => ChannelType

  after_create   :create_reward
  after_update   :update_reward
  before_destroy :delete_reward

  # temporary from 11 Jul
  before_save   :active_eq_true

  belongs_to :user
  belongs_to :owner
  belongs_to :restaurant

  has_one :reward
  
  # default_scope order('date DESC')

  scope :active, -> { where active: true }

  scope :today,       -> { where(:date => (Time.zone.today + 7.hour).to_date) }
  scope :yesterday,   -> { where(:date => (Time.zone.today - 1.day + 7.hour).to_date) }
  scope :next_7_days, -> { where(:date => (Time.zone.today + 1.day + 7.hour).to_date..(Time.zone.today + 7.days + 7.hour).to_date) }
  scope :all_visits, -> { where('active = 1 AND arrived = 1') }
  
  scope :past,     -> { 
    ids = Reservation.where('date = ? AND start_time >= ?',  Time.zone.today.strftime('%Y-%m-%d'), "2000-01-01 #{Time.now.strftime('%H:%M')}:00" ).map(&:id)
    ids = 0 if ids.empty?
    select = where('date <= ? AND id not in (?)',  Time.zone.today.strftime('%Y-%m-%d'), ids ) 
  }
  scope :upcoming, -> { 
    ids = Reservation.where('date = ? AND start_time <= ?',  Time.zone.today.strftime('%Y-%m-%d'), "2000-01-01 #{Time.now.strftime('%H:%M')}:00" ).map(&:id)
    ids = 0 if ids.empty?
    select = where('date >= ? AND id not in (?)',  Time.zone.today.strftime('%Y-%m-%d'), ids ) 
  }

  scope :by_date, lambda { |date|
     where(:date => date)
  }

  scope :by_month_year, lambda { |month_year = nil|
    month_year = Time.zone.today.strftime('%m-%Y') unless month_year.present?
    st = ("01-" + month_year).to_date
    fn = st.end_of_month
    where(:date => st..fn)
  }

  scope :completed, -> { past.where(active: false) }
  scope :no_show,   -> { where(no_show: false) }
  scope :cancel,    -> { where( active: false ) }
  scope :pending,   -> { upcoming.where(active: false) }
  
  scope :owners,     -> { where(:channel => 5..6) }
  scope :exc_owners, -> { where(:channel => 0..4) }
  
  # def start_time 
  #   self[:start_time].strftime('%H:%M') unless self[:start_time].blank?
  # end

  def active_eq_true
    self.active = true 
  end 

  def start_time_format
    self[:start_time].strftime('%H:%M') unless self[:start_time].blank?
  end

  def start_time=(value) 
    self[:start_time] = Time.zone.parse(value.to_s).utc 
  end

  def end_time_format
    self[:end_time].strftime('%H:%M') unless self[:end_time].blank?
  end

  def end_time=(value) 
    self[:end_time] = Time.zone.parse(value.to_s).utc 
  end

  def date_format 
    date.to_time.strftime('%d/%m/%Y') unless date.blank?
  end

  def date_format_user
    date.to_time.strftime('%d %b %Y') unless date.blank?
  end

  def date_format_ext
    date.to_time.strftime("#{date.day.ordinalize} %B %Y") unless date.blank? # 20th December 2013 
  end

  def created_at_format 
    created_at.to_time.strftime("#{created_at.day.ordinalize} %B %Y") # 20th December 2013 
  end

  def full_datetime
    "#{start_time_format} on #{date.strftime('%A')}, #{date_format_ext}" # 18:00 on Friday, 20th December 2013 
  end

  def status
    return "Cancelled" unless self.active
    if Time.zone.today <= self.date 
      if ( (Time.zone.today == self.date) && (Time.now.strftime('%H:%M') <= self.start_time_format) ) || Time.zone.today < self.date
        return "Upcoming"
      end
    end
    return "Past" 
  end
	
  def quality
    if self.user_id.nil?
      puts "manual reservation"
      res = Reservation.where(phone: self.phone)
#      return (( res.map(&:active).flatten.count(true) - res.map(&:no_show).flatten.count(true).to_f ) / res.map(&:active).flatten.count(true)*100).to_i
      return 100
    else
      puts "found userid #{self.id}"
      if self.user.reservations.map(&:active).flatten.count(true) == 0
        return 100
      else
        return (( self.user.reservations.map(&:active).flatten.count(true) - self.user.reservations.map(&:no_show).flatten.count(true).to_f ) / self.user.reservations.map(&:active).flatten.count(true)*100).to_i
      end
    end
  end
  
  def send_reminder_via_sms
#    Thread.new do
      require 'net/https'
      require 'open-uri'
      # uri = URI.parse("https://www.siptraffic.com/myaccount/sendsms.php?username=matthewfong&password=psyagbha&from=+6600000000&to=+#{self.phone}&text=#{self.verify_code}")
      # uri = URI.parse("https://www.siptraffic.com/myaccount/sendsms.php?username=matthewfong&password=psyagbha&from=+66875928489&to=+66#{self.phone.reverse.chop.reverse}&text=Welcome+to+Hungry+Hub.+Your+verification+code+is+#{self.verify_code}.+Please+verify+this+number+on+our+webpage+or+in+our+mobile+application.")
			if self.user.nil? then
        phone = self.phone
      else
        phone = self.user.phone
      end
      msg = URI.encode("restaurant reservation reminder for a party of #{self.party_size} at #{self.restaurant.name} on #{self.date.to_formatted_s(:rfc822)} starting at #{self.start_time.to_formatted_s(:time)}. See you soon.")
      uri = URI.parse("http://api.rushsms.com:8080/?username=rus-hungryhub&password=94GrsVw3&type=0&delivery=1&mobile=66#{phone.reverse.chop.reverse}&sender=Hungry+Hub&message=#{msg}")
      http = Net::HTTP.new(uri.host, uri.port)
#      http.use_ssl = true
#      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.get(uri.request_uri)
#    end
  end

  def self.generete_sms_reminders
    d = (Time.zone.now+1.hour).to_datetime.to_date
    s = Time.new(2000,1,1,(Time.zone.now + 1.hour).to_datetime.hour,(Time.zone.now + 1.hour).to_datetime.minute,0)
    res = Reservation.find_all_by_date_and_start_time(d,s).each do |r|
      r.send_reminder_via_sms
      puts "sent sms for id:#{r.id}"
    end
    puts "done sending out reminders"
  end


private

  def start_end_time
    if start_time > end_time
      self.errors.add(:start_time, "Start time can't be after end time.")
    end
  end

  def party_size_available_validation
    unless is_avilabale_reservation?
      self.errors.add(:party_size, "Please, check restaurant page for available date/time and places.")
    end
  end

  # TODO
  def is_avilabale_reservation?
    Restaurant.find(restaurant_id).inventories.each do |inv| 
      if inv.date == date
        if inv.start_time.strftime('%H:%M') <= start_time && 
           inv.end_time.strftime('%H:%M') >= end_time
          if inv.quantity_available >= party_size
            return true
          end
        end
        return false
      end
    end 
    false
  end

  def unreg_user_validation
    return unless user_id.blank?

    if name.blank?
      self.errors.add(:name,  "Fill name field")
    end
    
    if email.blank?
      self.errors.add(:email, "Fill email field")
    end

    if phone.blank?
      self.errors.add(:phone, "Fill phone field")
    end

  end

  def restaurant_id_validation
    unless is_restaurant_id_real?
      self.errors.add(:restaurant_id, "Provide correct Restaurant ID")
    end
  end

  def is_restaurant_id_real?
    begin
      Restaurant.find(restaurant_id)
      return true
    rescue
      return false
    end
    false
  end

  def date_validation
    unless is_date_valid?
      self.errors.add(:date, "Check inventory for picked day.")
    end
  end

  def is_date_valid?
    return true unless owner_id.blank?  # not check available status for owners reservations
    found = false
    begin
      Restaurant.find(restaurant_id).inventories.each do |inv|
        if inv.date.year == date.year && inv.date.month == date.month && inv.date.day == date.day
          found = true
        end
      end
    rescue
      return false
    end
    found
  end

  def create_reward
    if user_id.present?
      Reward.create( user_id: user_id, 
                     reservation_id: id, 
                     restaurant_id: restaurant_id,
                     points_total: 10, 
                     points_pending: 10,    
#                     points_total: 5*party_size, 
#                     points_pending: 5*party_size,    
                     description: "")
    end
    UserMailer.booking_create(self.user.id, self.id).deliver if user_id.present?
    OwnerMailer.booking_create(self.id).deliver
  end

  def update_reward
    if user_id.present?
      reward = Reward.where(:reservation_id => id).first
      if reward.present?
        reward.update_attributes( points_total: 10, 
                                  points_pending: 10,
                                  restaurant_id: restaurant_id )
      end
    end
#    UserMailer.booking_update(self.user.id, self.id).deliver if user_id.present?
#    OwnerMailer.booking_update(self.id).deliver
  end

  def delete_reward
    if user_id.present?
      reward = Reward.where(:reservation_id => id).first
      reward.destroy
    end
    UserMailer.booking_removed(self.user.id, self.id).deliver if user_id.present?
    OwnerMailer.booking_removed(self.id).deliver
  end
  
end
