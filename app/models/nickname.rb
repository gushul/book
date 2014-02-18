# encoding: utf-8
class Nickname < ActiveRecord::Base
  attr_accessible :nickname, :user_id, :restaurant_id

  belongs_to :user
  belongs_to :restaurant

  validates :nickname,      :presence => true, :uniqueness => true
  validates :user_id,       :presence => true
  validates :restaurant_id, :presence => true

  validate  :user_per_restaraunt_uniquness  

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

end