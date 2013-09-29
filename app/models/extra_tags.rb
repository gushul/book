class CuisineTag < ActiveRecord::Base
  attr_accessible :title, :type

  validates :title, :presence => true
 
  # has_and_belongs_to_many :restaurants
end
