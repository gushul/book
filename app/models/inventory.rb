class Inventory < ActiveRecord::Base
  attr_accessible :date, :restaurant_id, :start_time,
                  :end_time, :quantity_available

  validates :restaurant_id,      :presence => true
  validates :date,               :presence => true
  validates :start_time,         :presence => true
  validates :end_time,           :presence => true
  validates :quantity_available, :presence => true,
      :numericality => { :greater_than_or_equal_to => 1 }

  belongs_to :restaurant
end
