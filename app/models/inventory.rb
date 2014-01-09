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
 
  scope :find_available_time, lambda { |date, time, people, restaurant_id|
    # limit 3
    Inventory.where('restaurant_id = ? AND date = ? AND start_time >= ? AND quantity_available >= ?', restaurant_id, date, "2000-01-01 #{time}:00", people).limit(3)
  }

  scope :by_min_and_date, lambda { |min, date| 
    where('start_time LIKE ? AND date = ?', "%:#{min}:00", date) 
  }

  belongs_to :restaurant

  def start_time_hour
    start_time.strftime("%H").to_i
  end
  
end
