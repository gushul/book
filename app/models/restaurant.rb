# encoding: utf-8
class Restaurant < ActiveRecord::Base
  attr_accessible :category, :lat, :lng, :misc, 
                  :name, :owner_id, :price,
                  :cuisine_tags_attributes,
                  :days_in_advance, :min_booking_time, :res_duration,
                  :cuisine_list, :cuisine_tag_ids

  PARKING = [ "Yes", "No", "Valet" ]
  DRINKS  = [ "Alcohol", "Wine", "Cocktails", "Beer" ]
  MISC    = [ "Child Friendly", "Casual Dress", "Formal Dress", "Large Groups" ]
  PAYMENT = [ "Mastercard", "American Express", "Visa" ]
  MEALS   = [ "Breakfast", "Lunch", "Dinner", "Late Night" ]
 
  validates :name,  :presence => true
  validates :lng,   :presence => true
  validates :lat,   :presence => true
  validates :price, :presence => true

  validates :days_in_advance,  :presence => true, 
                :numericality => { 
                  :greater_than_or_equal_to => 0, 
                  :less_than_or_equal_to => 180  }
  validates :min_booking_time, :presence => true,
                :numericality => { 
                  :greater_than_or_equal_to => 15, 
                  :less_than_or_equal_to =>  720 }
  validates :res_duration,     :presence => true, 
                :numericality => { 
                  :greater_than_or_equal_to => 15, 
                  :less_than_or_equal_to =>  720 }
  
  validates :price, :numericality => { 
                :greater_than_or_equal_to => 1, 
                :less_than_or_equal_to => 5  }

  has_many :reservations
  has_many :inventories
  has_many :inventory_templates
  has_and_belongs_to_many :cuisine_tags

  accepts_nested_attributes_for :cuisine_tags, :allow_destroy => :true,
          :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
     
  belongs_to :owner
    
  #todo: refactor
  class << self
    def with_price price
      if price.class == Array
        case price.length
          when 2..5
            where("price >= ? AND price <= ?", price[0].to_i, price.last.to_i)
          else
            where(price: price[0])
        end
      else
        where(price: price)
      end
    end 
  
    def with_cuisine cuisine
      if cuisine.class == Array
        case cuisine.length
          when 2
            joins(:cuisine_tags).where('cuisine_tags.title LIKE ? or cuisine_tags.title LIKE ?', "%#{cuisine[0]}%", "%#{cuisine[1]}%")
          when 3
            joins(:cuisine_tags).where('cuisine_tags.title LIKE ? or cuisine_tags.title LIKE ? or cuisine_tags.title LIKE ?', "%#{cuisine[0]}%", "%#{cuisine[1]}%", "%#{cuisine[2]}%")
          else
            joins(:cuisine_tags).where('cuisine_tags.title LIKE ?', "%#{cuisine[0]}%")
        end
      else
        # where('cuisine LIKE ?', "%#{cuisine}%")
        # joins(:cuisine_tags).where('cuisine LIKE ?', "%#{cuisine}%")
      end
    end

    def with_location location
      where('location LIKE ?', "%#{location}%")
    end
  end

  
    
end

   