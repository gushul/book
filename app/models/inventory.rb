# encoding: utf-8
class Inventory < ActiveRecord::Base
  paginates_per 20
  
  attr_accessible :date, :restaurant_id, :start_time,
                  :end_time, :quantity_available

  validates :restaurant_id,      :presence => true
  validates :date,               :presence => true
  validates :start_time,         :presence => true
  validates :end_time,           :presence => true
  validates :quantity_available, :presence => true,
      :numericality => { :greater_than_or_equal_to => 1 }

  scope :future, -> { where("date >= ?", DateTime.now.to_date) }

  belongs_to :restaurant
end
