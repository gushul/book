#encoding: utf-8 

RestaurantTag.delete_all
cuisines = %w[Any American Bar Barbeque Breakfast Chinese French Franchise Fusion Grill Hotel Italian Japanese Rooftop Pub Shabu Sukiyaki Tea/Coffee Tai]  
cuisines.each {|c| RestaurantTag.create(title: "Cuisine:#{c}") }

prices = %w[$ $$ $$$ $$$$ $$$$$]
prices.each {|p| RestaurantTag.create(title: "Price:#{p}") }

stars = 1..5
stars.each {|s| RestaurantTag.create(title: "Star:#{s}") }

parking = %w[Yes No Valet]
parking.each {|p| RestaurantTag.create(title: "Parking:#{p}") }

drinking = %w[Alcohol Beer Cocktails Wine]
drinking.each {|d| RestaurantTag.create(title: "Drinking:#{d}") }

misc = ["Casual Dress", "Child Friendly", "Formal Dress", "Large Groups"]
misc.each {|m| RestaurantTag.create(title: "Misc:#{m}") }

payments = ["American Express", "Credit Card","Mastercard", "Visa"]
payments.each {|p| RestaurantTag.create(title: "Payment:#{p}") }

meals = ["Breakfast", "Dinner", "Late Night", "Lunch"]
meals.each {|m| RestaurantTag.create(title: "Meals:#{m}") }
# ==================================================================
puts "*** Tags created ***"

User.delete_all
User.create(email: "user@mail.com", password: "secret12", username: "sample user")
puts "*** User created ***"

Owner.delete_all
Owner.create(email: "owner1@mail.com", password: "secret12", owner_name: "COCA Surawong owner")
Owner.create(email: "owner2@mail.com", password: "secret12", owner_name: "Roast Coffee & Eatery owner")
Owner.create(email: "owner3@mail.com", password: "secret12", owner_name: "Akiyoshi Sukhumvit 53")
Owner.create(email: "owner4@mail.com", password: "secret12", owner_name: "Akiyoshi Sukhumvit 53")
# ==================================================================
puts "*** Owners created ***"

Restaurant.delete_all
Restaurant.create(name: "COCA Surawong", category: "Chinese, Sukiyaki/Shabu", misc: "ซ.อนุมานราชธน ถ.สุรวงศ์ Suriyawong , Bang Rak , Bangkok", lat: 13.7282012786, lng: 100.5301216487, owner_id: Owner.first.id, price: 2, days_in_advance: 90, min_booking_time: 30, res_duration: 30)
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Chinese")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Shabu")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Sukiyaki")

Restaurant.create(name: "Roast Coffee & Eatery", category: "American, Tea/Coffee, Breakfast", misc: "2/F, Seenspace, Thonglor Soi 13, Bangkok, 10110 (2nd floor Seen Space Thong Lor) Seenspace Thonglor , คลองเตยเหนือ , วัฒนา , กรุงเทพมหานคร 10110", lat: 13.7339240000, lng: 100.5808190000, owner_id: Owner.find_by_email("owner2@mail.com").id, price: 1, days_in_advance: 20, min_booking_time: 15, res_duration: 15)
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:American")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Tea/Coffee")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Breakfast")

Restaurant.create(name: "Akiyoshi Sukhumvit 53", category: "Barbeque/Grill, Sukiyaki/Shabu", misc: "สุขุมวิท 53, เขต วัฒนา, กรุงเทพมหานคร (อยู่ใกล้ ทองหล่อ ซ.5) Khlong Toei Nuea , Vadhana , Bangkok 10110", lat: 13.7309640000, lng: 100.5777670000, owner_id: Owner.find_by_email("owner3@mail.com").id, price: 3, days_in_advance: 20, min_booking_time: 45, res_duration: 45)
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Barbeque")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Grill")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Sukiyaki")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Shabu")

Restaurant.create(name: "Bangkok Burger Co. Thonglor 10", category: "Franchise, American", misc: "ทองหล่อ 10, กรุงเทพมหานคร (ตึก Opus เข้าซอยทองหล่อ 10 จากทางซอยทองหล่อ 50 เมตรอยู่ซ้ายมือ) กรุงเทพมหานคร 10110", lat: 13.7331740000, lng: 100.5822730000, owner_id: Owner.find_by_email("owner4@mail.com").id, price: 3, days_in_advance: 10, min_booking_time: 60, res_duration: 75)
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Franchise")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:American")
# ==================================================================
puts "*** Restaurants created ***"