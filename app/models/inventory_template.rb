class InventoryTemplate < ActiveRecord::Base
  attr_accessible :start_time, :end_time, :name, :primary, 
                  :quantity_available, :restaurant_id
  
  validates :restaurant_id,      :presence => true
  validates :name,               :presence => true
  validates :start_time,         :presence => true
  validates :end_time,           :presence => true
  validates :quantity_available, :presence => true,
            :numericality => { :greater_than_or_equal_to => 1 }

  belongs_to :restaurant
end
