class Reservation < ActiveRecord::Base
 
  attr_accessible :active, :date, :end_time, :party_size, 
                  :start_time, :user_id, :restaurant_id

  validates :user_id,       :presence => true
  validates :restaurant_id, :presence => true
  validates :date,          :presence => true
  validates :start_time,    :presence => true
  validates :end_time,      :presence => true
  validates :party_size,    :presence => true
                                               
  validates :party_size, :numericality => { 
      :greater_than => 0 }

  belongs_to :user
  belongs_to :restaurant

  has_one :reward
  
end
