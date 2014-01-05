# encoding: utf-8
class Vip < ActiveRecord::Base

  attr_accessible :restaurant_id, :user_id, :name, :phone

  validates :restaurant_id, :presence => true

  belongs_to :user
  belongs_to :restaurant

end