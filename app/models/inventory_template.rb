# encoding: utf-8
class InventoryTemplate < ActiveRecord::Base
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

end
