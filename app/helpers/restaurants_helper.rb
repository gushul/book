module RestaurantsHelper

  def join_restaurant_tags(restaurant)
    # restaurant.restaurant_tags.map { |t| t.title.slice( ((t.title.index(':')+1)..t.title.length) ) }.join(", ")
    restaurant.restaurant_tags.map { |t| t.title }.join(", ")
  end

  def price_to_dollars_symb(num)
    price = ""
    num.times { price += "$"}
    price
  end

end
