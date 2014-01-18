# encoding: utf-8
class Note < ActiveRecord::Base

  attr_accessible :restaurant_id, :user_id, :phone, :text

  validates :restaurant_id, :presence => true

  belongs_to :user
  belongs_to :restaurant

end