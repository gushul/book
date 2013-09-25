module RestaurantsHelper

  def join_cuisine_tags(restaurant)
    restaurant.cuisine_tags.map { |t| t.title }.join(", ")
  end

end
