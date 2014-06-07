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

  belongs_to :restaurant

  default_scope :order => :start_time

  scope :future, -> { where("date >= ?", DateTime.now.to_date) }
  
  scope :available, lambda { |date = DateTime.now.to_date, time = Time.now.to_s.slice(11..15) |
    where('date = ? AND inventories.start_time >= ?', date, "2000-01-01 #{time}:00" ) 
  }
 
  scope :find_available_time, lambda { |date, time, people, restaurant_id|
    # limit 3
    Inventory.where('restaurant_id = ? AND date = ? AND start_time >= ? AND quantity_available >= ?', restaurant_id, date, "2000-01-01 #{time}:00", people).limit(3)
  }

  scope :by_min_and_date, lambda { |min, date| 
    where('start_time LIKE ? AND date = ?', "%:#{min}:00", date) 
  }

  scope :by_hr_min, lambda { |time| 
    where('start_time LIKE ?', "%#{time}:00") 
  }

  scope :by_date, lambda { |date = Date.today | 
    where(:date => date)
  }

  scope :in_frame, lambda { |start_period, end_period|
    # start_period = "2014-06-06 10:00:00"
    # end_period = "2014-06-30 11:00:00"
    Inventory.where(:date => start_period.to_date...end_period.to_date,
                    :start_time => "2000-01-01 #{start_period.to_time.strftime('%H:%M')}:00".to_time..."2000-01-01 #{end_period.to_time.strftime('%H:%M')}:00".to_time)
  }

  def start_time_hour
    start_time.strftime("%H").to_i
  end

  def start_time_format
    start_time.strftime('%H:%M') unless start_time.blank?
  end

  def end_time_format
    end_time.strftime('%H:%M') unless end_time.blank?
  end

  def date_format 
    date.to_time.strftime('%m/%d/%Y') unless date.blank?
  end

  def date_format_ext
    date.to_time.strftime("#{date.day.ordinalize} %B %Y") unless date.blank? # 20th December 2013 
  end
  
end
