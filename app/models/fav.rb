class Fav < ActiveRecord::Base
  attr_accessible :restaurant_id, :user_id

  belongs_to :user
  belongs_to :restaurant
end
