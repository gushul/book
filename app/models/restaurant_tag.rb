# encoding: utf-8
class RestaurantTag < ActiveRecord::Base
  attr_accessible :restaurant_id, :title

  validates :title, :presence => true
 
  has_and_belongs_to_many :restaurants

  scope :ordered, order('title ASC')

  def title_format
    title.gsub( /.*:/, "" )
  end

end
