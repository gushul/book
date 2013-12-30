#encoding: utf-8 

RestaurantTag.delete_all
cuisines = %w[American Bar Barbeque Breakfast Chinese French Franchise Fusion Grill Hotel Italian Japanese Rooftop Pub Shabu Sukiyaki Tea/Coffee Tai]  
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

Owner.delete_all
Owner.create(email: "owner1@mail.com", password: "secret12", owner_name: "COCA Surawong owner")
Owner.create(email: "owner2@mail.com", password: "secret12", owner_name: "Roast Coffee & Eatery owner")
Owner.create(email: "owner3@mail.com", password: "secret12", owner_name: "Akiyoshi Sukhumvit 53 owner")
Owner.create(email: "owner4@mail.com", password: "secret12", owner_name: "Bangkok Burger Co. Thonglor 10 owner")
Owner.create(email: "owner5@mail.com", password: "secret12", owner_name: "5th sample owner")
# ==================================================================
puts "*** Owners created ***"

Restaurant.delete_all
Inventory.delete_all
InventoryTemplate.delete_all
InventoryTemplateGroup.delete_all
Photo.delete_all
Restaurant.create(name: "COCA Surawong", misc: "ซ.อนุมานราชธน ถ.สุรวงศ์ Suriyawong , Bang Rak , Bangkok", lat: 13.7282012786, lng: 100.5301216487, owner_id: Owner.first.id, days_in_advance: 1, min_booking_time: 30, res_duration: 30, largest_table: 5 )
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Chinese")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Shabu")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Sukiyaki")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Price:$")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Parking:Yes")
Restaurant.first.restaurant_tags << RestaurantTag.find_by_title("Star:2")
Photo.create(title: "sample_thumbnail", picture: File.open("app/assets/images/_restaurant_seed_5.png"), is_cover: true, restaurant_id: Restaurant.last.id) 

InventoryTemplateGroup.create(name: "Main", restaurant: Restaurant.first, primary: true )
InventoryTemplateGroup.create(name: "Weekends", restaurant: Restaurant.first, primary: true )

Restaurant.first.update_attributes(mon: InventoryTemplateGroup.first.id,
                                   tue: InventoryTemplateGroup.first.id,
                                   wed: InventoryTemplateGroup.first.id,
                                   thu: InventoryTemplateGroup.first.id,
                                   fri: InventoryTemplateGroup.first.id,
                                   sat: InventoryTemplateGroup.last.id,
                                   sun: InventoryTemplateGroup.last.id)

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 10:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 10:15:00", end_time: "2000-01-01 10:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 10:30:00", end_time: "2000-01-01 10:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 10:45:00", end_time: "2000-01-01 11:00:00", quantity_available: 10 )

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 11:00:00", end_time: "2000-01-01 11:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 11:15:00", end_time: "2000-01-01 11:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 11:30:00", end_time: "2000-01-01 11:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 11:45:00", end_time: "2000-01-01 12:00:00", quantity_available: 10 )

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 12:00:00", end_time: "2000-01-01 12:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 12:15:00", end_time: "2000-01-01 12:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 12:30:00", end_time: "2000-01-01 12:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 12:45:00", end_time: "2000-01-01 13:00:00", quantity_available: 10 )

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 13:00:00", end_time: "2000-01-01 13:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 13:15:00", end_time: "2000-01-01 13:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 13:30:00", end_time: "2000-01-01 13:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 13:45:00", end_time: "2000-01-01 14:00:00", quantity_available: 10 )

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 14:00:00", end_time: "2000-01-01 14:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 14:15:00", end_time: "2000-01-01 14:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 14:30:00", end_time: "2000-01-01 14:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 14:45:00", end_time: "2000-01-01 15:00:00", quantity_available: 10 )

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 15:00:00", end_time: "2000-01-01 15:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 15:15:00", end_time: "2000-01-01 15:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 15:30:00", end_time: "2000-01-01 15:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 15:45:00", end_time: "2000-01-01 16:00:00", quantity_available: 10 )

InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 16:00:00", end_time: "2000-01-01 16:15:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 16:15:00", end_time: "2000-01-01 16:30:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 16:30:00", end_time: "2000-01-01 16:45:00", quantity_available: 10 )
InventoryTemplate.create( inventory_template_group_id: InventoryTemplateGroup.first.id, start_time: "2000-01-01 16:45:00", end_time: "2000-01-01 17:00:00", quantity_available: 10 )

Inventory.create(date: DateTime.now.to_date, quantity_available: 10, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 17:00:00", restaurant_id: Restaurant.first.id)
Inventory.create(date: DateTime.now.tomorrow.to_date, quantity_available: 10, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 17:00:00",restaurant_id: Restaurant.first.id)

Restaurant.create(name: "Roast Coffee & Eatery", misc: "2/F, Seenspace, Thonglor Soi 13, Bangkok, 10110 (2nd floor Seen Space Thong Lor) Seenspace Thonglor , คลองเตยเหนือ , วัฒนา , กรุงเทพมหานคร 10110", lat: 13.7339240000, lng: 100.5808190000, owner_id: Owner.find_by_email("owner2@mail.com").id, days_in_advance: 20, min_booking_time: 15, res_duration: 15, largest_table: 5 )
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:American")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Tea/Coffee")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Breakfast")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Price:$$")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Parking:No")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Star:3")
Photo.create(title: "sample_thumbnail", picture: File.open("app/assets/images/_restaurant_seed_2.png"), is_cover: true, restaurant_id: Restaurant.last.id) 

Restaurant.create(name: "Akiyoshi Sukhumvit 53", misc: "สุขุมวิท 53, เขต วัฒนา, กรุงเทพมหานคร (อยู่ใกล้ ทองหล่อ ซ.5) Khlong Toei Nuea , Vadhana , Bangkok 10110", lat: 13.7309640000, lng: 100.5777670000, owner_id: Owner.find_by_email("owner3@mail.com").id,  days_in_advance: 20, min_booking_time: 45, res_duration: 45, largest_table: 5 )
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Barbeque")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Grill")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Sukiyaki")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Shabu")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Price:$$$$")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Drinking:Alcohol")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Drinking:Cocktails")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Star:4")
Photo.create(title: "sample_thumbnail", picture: File.open("app/assets/images/_restaurant_seed_3.png"), is_cover: true, restaurant_id: Restaurant.last.id) 

Restaurant.create(name: "Bangkok Burger", misc: "ทองหล่อ 10, กรุงเทพมหานคร (ตึก Opus เข้าซอยทองหล่อ 10 จากทางซอยทองหล่อ 50 เมตรอยู่ซ้ายมือ) กรุงเทพมหานคร 10110", lat: 13.7331740000, lng: 100.5822730000, owner_id: Owner.find_by_email("owner4@mail.com").id,  days_in_advance: 10, min_booking_time: 60, res_duration: 75, largest_table: 5 )
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Franchise")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:American")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Price:$$$")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Meals:Breakfast")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Meals:Dinner")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Payment:Visa")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Star:5")
Photo.create(title: "sample_thumbnail", picture: File.open("app/assets/images/_restaurant_seed_4.png"), is_cover: true, restaurant_id: Restaurant.last.id) 

Restaurant.create(name: "Above Eleven Rooftop",  misc: "38/8 สุขุมวิท 11 (ชั้น 33 โรงแรม Fraser Suites ซอยสุขุมวิท 11 นานา เข้าซอยแล้วเลี้ยวซ้าย ทางจะบังคับเลี้ยวขวา โรงแรมอยู่ขวามือ) คลองตันเหนือ , วัฒนา , กรุงเทพมหานคร", lat: 13.7479730000, lng: 100.5564750000, owner_id: Owner.find_by_email("owner5@mail.com").id,  days_in_advance: 10, min_booking_time: 90, res_duration: 75, largest_table: 5 )
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Rooftop")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Fusion")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Cuisine:Pub")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Price:$$$$")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Meals:Breakfast")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Meals:Lunch")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Meals:Dinner")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Payment:Visa")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Payment:Mastercard")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Payment:American Express")
Restaurant.last.restaurant_tags << RestaurantTag.find_by_title("Star:1")
Photo.create(title: "sample_thumbnail", picture: File.open("app/assets/images/_restaurant_seed_1.png"), is_cover: true, restaurant_id: Restaurant.last.id) 
# ==================================================================
puts "*** Restaurants created with tags and photos ***"

User.delete_all
User.create(email: "user1@mail.com", password: "secret12", username: "sample user 1", phone: "0123456789")
User.create(email: "user2@mail.com", password: "secret12", username: "sample user 2", phone: "0123456789")
User.create(email: "waqar@mail.com", password: "secret12", username: "waqar's user", phone: "0123456789")
# ==================================================================
puts "*** Users created ***"

Reservation.delete_all
Reservation.create(user_id: User.first.id, restaurant_id: Restaurant.first.id, date: DateTime.now.to_date, start_time: "2000-01-01 13:30:00", end_time: "2000-01-01 15:00:00", party_size: 10, active: true )
Reservation.create(user_id: User.first.id, restaurant_id: Restaurant.first.id, date: DateTime.now.tomorrow.to_date, start_time: "2000-01-01 11:00:00", end_time: "2000-01-01 12:30:00", party_size: 10, active: false )
Reservation.create(user_id: User.first.id, restaurant_id: Restaurant.last.id, date: "2013-11-01", start_time: "2000-01-01 16:00:00", end_time: "2000-01-01 16:45:00", party_size: 4, active: true )
Reservation.create(user_id: User.last.id, restaurant_id: Restaurant.last.id, date: "2013-11-02", start_time: "2000-01-01 14:00:00", end_time: "2000-01-01 14:30:00", party_size: 3, active: true )
Reservation.create(user_id: User.last.id, restaurant_id: Restaurant.last.id, date: "2013-11-12", start_time: "2000-01-01 15:00:00", end_time: "2000-01-01 15:30:00", party_size: 1, active: true )

Reservation.create(restaurant_id: Restaurant.first.id, date: DateTime.now.to_date, start_time: "2000-01-01 16:00:00", end_time: "2000-01-01 16:30:00", party_size: 10, active: false, name: "Sample-Name1", email: "mail_1@mail.com", phone: "+646654646", owner_id: Restaurant.first.owner.id)
Reservation.create(restaurant_id: Restaurant.last.id, date: "2013-10-09", start_time: "2000-01-01 16:00:00", end_time: "2000-01-01 16:30:00", party_size: 2, active: true, name: "Sample-Name2", email: "mail_2@mail.com", phone: "+646622246", owner_id: Restaurant.last.owner.id)
# ==================================================================
puts "*** Reservations created ***"