# encoding: utf-8
class Reward < ActiveRecord::Base
  attr_accessible :user_id, :reservation_id, :restaurant_id,
                  :points_pending, :points_total, 
                  :description

  belongs_to :user
  belongs_to :reservation  
  belongs_to :restaurant  

  scope :redeemed, -> { where('points_total <= 0') }
  scope :received, -> { where('points_total > 0') }

end
