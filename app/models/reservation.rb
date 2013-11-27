# encoding: utf-8
class Reservation < ActiveRecord::Base
 
  attr_accessible :active, :date, :party_size, 
                  :start_time, :end_time,
                  :user_id, :owner_id, :restaurant_id,
                  :name, :email, :phone,
                  :no_show, :arrived, :table,
                  :special_request
 
  # validates :user_id,       :presence => true
  # validates user/owner id presence
  validates :restaurant_id, :presence => true
  validates :date,          :presence => true
  validates :start_time,    :presence => true
  validates :end_time,      :presence => true
  validates :party_size,    :presence => true

  validate  :unreg_user_validation            
  validate  :restaurant_id_validation            
  validate  :date_validation, :if => :is_restaurant_id_real?
  # validate  :party_size_available_validation

  validates :party_size, :numericality => { 
      :greater_than => 0 }

  after_create :create_reward
  after_update :update_reward

  belongs_to :user
  belongs_to :owner
  belongs_to :restaurant

  has_one :reward

  scope :active, -> { where active: true }

  def start_time 
    self[:start_time].strftime('%H:%M') unless self[:start_time].blank?
  end

  def start_time=(value) 
    self[:start_time] = Time.zone.parse(value.to_s).utc 
  end

  def end_time 
    self[:end_time].strftime('%H:%M') unless self[:end_time].blank?
  end

  def end_time=(value) 
    self[:end_time] = Time.zone.parse(value.to_s).utc 
  end


private

  def party_size_available_validation
    unless is_avilabale_reservation
      self.errors.add(:party_size, "Please, check restaurant page for available date/time and places.")
    end
  end

  # TODO
  def is_avilabale_reservation
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
    Reward.create( user_id: user_id, 
                   reservation_id: id, 
                   points_total: 5*party_size, 
                   points_pending: 5*party_size,    
                   description: "")
    # UserMailer.booking_create(current_user, @reservation).deliver
    # OwnerMailer.booking_create(@reservation).deliver
  end

  def update_reward
    reward = Reward.where(:reservation_id => id).first
    reward.update_attributes( points_total: 5*party_size, 
                              points_pending: 5*party_size )
    # UserMailer.booking_update(current_user, @reservation).deliver
    # OwnerMailer.booking_update(@reservation).deliver
  end
  
end
