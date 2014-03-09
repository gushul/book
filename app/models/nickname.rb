# encoding: utf-8
class Nickname < ActiveRecord::Base
  attr_accessible :nickname, :user_id, :restaurant_id, :phone

  belongs_to :user
  belongs_to :restaurant

  validates :nickname,      :presence => true#, :uniqueness => true
  # validates :user_id,       :presence => true
  validates :restaurant_id, :presence => true
  # validates :phone,         :presence => true, :uniqueness => true
  validate  :phone_number_validation, :if => "phone?"
  validate  :user_per_restaraunt_uniquness, :if => "user_id?"

private
  
  def user_per_restaraunt_uniquness   
    if is_not_uniq?
      self.errors.add(:restaurant_id, "You already have a nickname in this restaurant.")
    end       
  end

  def is_not_uniq?
    us = User.find(user_id).nicknames.where(restaurant_id: restaurant_id).first
    if us.present? && self.new_record?
      return true
    end
    false
  end

  def phone_number_validation
    unless check_phone_number
      self.errors.add(:phone, "Incorrect phone number format")
    end
  end

  def check_phone_number
    if phone.length == 10 and phone[0,1].to_i == 0
      return true
    end
    false
  end

end