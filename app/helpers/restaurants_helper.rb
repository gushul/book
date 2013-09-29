module RestaurantsHelper

  def join_cuisine_tags(restaurant)
    restaurant.cuisine_tags.map { |t| t.title }.join(", ")
  end

  def price_to_dollars_symb(num)
    price = ""
    num.times { price += "$"}
    price
  end

end
