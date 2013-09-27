CuisineTag.delete_all
cuisines = %w[Any American Bar Barbeque Breakfast Chinese French Fusion Grill Hotel Italian Rooftop Pub Shabu Sukiyaki]  
cuisines.each {|c| CuisineTag.create(title: c)}
