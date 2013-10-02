class RestaurantTag < ActiveRecord::Base
  attr_accessible :restaurant_id, :title

  validates :title, :presence => true
 
  has_and_belongs_to_many :restaurants
end
