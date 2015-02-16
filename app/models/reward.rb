# encoding: utf-8
class Reward < ActiveRecord::Base
  attr_accessible :user_id, :reservation_id, :restaurant_id,
                  :points_pending, :points_total, 
                  :description, :redeemed

  belongs_to :user
  belongs_to :reservation  
  belongs_to :restaurant  

  scope :redeemed, -> { where('points_total <= 0') }
  scope :received, -> { where('points_total > 0 AND points_pending=0') }

  def self.set_points_pending
    Reservation.past.map { |res| 
      res.reward.update_attributes(points_pending:0) if res.reward.present? && res.active && !res.no_show 
    }
  end

end
