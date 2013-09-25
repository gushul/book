class Reward < ActiveRecord::Base
  attr_accessible :user_id, :reservation_id, 
                  :points_pending, :points_total, 
                  :description

   belongs_to :user
   belongs_to :reservation  
end
