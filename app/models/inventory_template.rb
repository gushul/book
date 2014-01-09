# encoding: utf-8
class InventoryTemplate < ActiveRecord::Base
  paginates_per 20
  
  attr_accessible :start_time, :end_time, 
                  :quantity_available,
                  # :name, :primary, 
                  :inventory_template_group_id
      
  validates :inventory_template_group_id, :presence => true
  # validates :restaurant_id,      :presence => true
  # validates :name,               :presence => true
  validates :start_time,         :presence => true
  validates :end_time,           :presence => true
  validates :quantity_available, #:presence => true,
            :numericality => { :greater_than_or_equal_to => 0 }

  # belongs_to :restaurant
  belongs_to :inventory_template_group

  scope :by_min, lambda { |min| 
    where("start_time LIKE ?", "%:#{min}:00") 
  }

  def start_time_hour
    start_time.strftime("%H").to_i
  end

end
