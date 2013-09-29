#encoding: utf-8 

CuisineTag.delete_all
cuisines = %w[Any American Bar Barbeque Breakfast Chinese French Fusion Grill Hotel Italian Japanese Rooftop Pub Shabu Sukiyaki Tea/Coffee Tai]  
cuisines.each {|c| CuisineTag.create(title: c)}

User.delete_all
User.create(email: "user@mail.com", password: "secret12", username: "sample user")

Owner.delete_all
Owner.create(email: "owner1@mail.com", password: "secret12", owner_name: "COCA Surawong owner")
Owner.create(email: "owner2@mail.com", password: "secret12", owner_name: "Roast Coffee & Eatery owner")

Restaurant.delete_all
Restaurant.create(name: "COCA Surawong", category: "Chinese, Sukiyaki/Shabu", misc: "ซ.อนุมานราชธน ถ.สุรวงศ์ Suriyawong , Bang Rak , Bangkok", lat: 13.7282012786, lng: 100.5301216487, owner_id: Owner.first.id, price: 2, days_in_advance: 90, min_booking_time: 30, res_duration: 30)
Restaurant.first.cuisine_tags << CuisineTag.find_by_title("Chinese")
Restaurant.first.cuisine_tags << CuisineTag.find_by_title("Shabu")
Restaurant.first.cuisine_tags << CuisineTag.find_by_title("Sukiyaki")

Restaurant.create(name: "Roast Coffee & Eatery", category: "American, Tea/Coffee, Breakfast", misc: "2/F, Seenspace, Thonglor Soi 13, Bangkok, 10110 (2nd floor Seen Space Thong Lor) Seenspace Thonglor , คลองเตยเหนือ , วัฒนา , กรุงเทพมหานคร 10110", lat: 13.7339240000, lng: 100.5808190000, owner_id: Owner.last.id, price: 1, days_in_advance: 20, min_booking_time: 15, res_duration: 15)
Restaurant.last.cuisine_tags << CuisineTag.find_by_title("American")
Restaurant.last.cuisine_tags << CuisineTag.find_by_title("Tea/Coffee")
Restaurant.last.cuisine_tags << CuisineTag.find_by_title("Breakfast")
