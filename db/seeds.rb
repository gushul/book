#encoding: utf-8 

RestaurantTag.delete_all
cuisines = ["Thai","Indian","Chinese","Italian","French","International","Japanese","Sukiyaki / Shabu","Wine Bar","Noodle","Buffet","Fusion","Pub / Bar","Rooftop","Seafood","Steak","Noodle","Ramen","Sushi","Live Band","Waterside","Romantic","Korean","Arabic","Café / Coffee Shop","Barbeque / Grill","Breakfast / Brunch","American","Hotel Restaurant","Mexican","Pizza","Vegetarian","Bakery / Dessert" ]
cuisines.each {|c| RestaurantTag.create(title: "Cuisine:#{c}") }

locations = ["Asok","Charoen Krung","Charoen Nakorn","Chatuchak","Chong Nonsi","Ekamai","Kaset Nawamin","Ladprao","Langsuan","Nana","Phaya Thai","Phrom Phong","Pinklao","Ploenchit","Pratunaam","Rajdamri","Rajthavee","Rajthevee","Ram Intra","Rama 1","Rama 3","Rama 4","Rama 9","Ratchada","Sala Daeng","Sathorn","Sathu Pradit","Siam","Silom","Sukhumvit","Surawong","Suvarnabhumi","Thonglor" ]
locations.each {|p| RestaurantTag.create(title: "Location:#{p}") }

prices = %w[$ $$ $$$ $$$$]
prices.each {|p| RestaurantTag.create(title: "Price:#{p}") }

parking = %w[Yes Street Valet None]
parking.each {|p| RestaurantTag.create(title: "Parking:#{p}") }

stars = Array.new(9) { |e| e = 1 + e*0.5 }    # 1.0, 1.5 ... 5.0
stars.each {|s| RestaurantTag.create(title: "Star:#{s}") }

payments = ["Yes", "No"]
payments.each {|p| RestaurantTag.create(title: "Payment:#{p}") }

drinking = %w[Alcohol Beer Cocktail Spirit Wine None]
drinking.each {|d| RestaurantTag.create(title: "Drinking:#{d}") }

kids = %w[Yes No]
kids.each {|m| RestaurantTag.create(title: "Good with Kids:#{m}") }

# ==================================================================
puts "*** Tags created ***"

Owner.delete_all
restaurant_names = ["COCA Surawong", "Roast Coffee & Eatery","Tenyuu Grand","Kuppa","Kuppadeli","Akiyoshi Sukumvit 53","Neil's Tavern Asok","Aoi Silom","Ramentei Surawong","Water Library","Seiryu Sushi","Nobu Thonglor","Bourbon Street Restaurant, Oyster Bar & Boutique Hotel","Indian Host" ]
restaurant_names.each_with_index do |restaurant_name, i| 
  Owner.create( email: "owner#{i}@mail.com", 
                password: "secret12", 
                owner_name: "#{restaurant_name} Owner" )
end
# ==================================================================
puts "*** Owners created ***"

Restaurant.delete_all
Inventory.delete_all
InventoryTemplate.delete_all
InventoryTemplateGroup.delete_all
Photo.delete_all

owner_ids = Owner.all.map {|o| o.id }
max_covers = ["15","12","15","10","10","15","10","10","10","15","10","10","15","15"]
booking_in_advances = ["60","60","30", "30", "15","30","60", "30","30","60", "15","15","30","30"]
turnaround_times    = ["90","90","120","120","75","90","120","75","75","180","75","90","90","75"]
restaurant_names.each_with_index do |restaurant_name, i| 
  Restaurant.create( name: restaurant_name, 
    misc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.", 
    lat: "13.72#{rand(9)}8212786", 
    lng: "100.53#{rand(9)}1216487", 
    owner_id: owner_ids[i], 
    days_in_advance: 1, 
    min_booking_time: booking_in_advances[i], 
    res_duration: turnaround_times[i], 
    largest_table: max_covers[i] )
end

restaurant_cuisines = ["Chinese, Sukiyaki / Shabu","American, Café / Coffee Shop, Breakfast / Brunch, Bakery / Dessert","Japanese, Sushi","Thai, Bakery / Dessert, Café / Coffee Shop, Italian","Bakery / Dessert, Breakfast / Brunch","Sukiyaki / Shabu, Barbeque / Grill","Bakery / Dessert, International, Steak","Japanese","Ramen, Noodle, Japanese","French","Sushi, Japanese","Sushi, Japanese","Mexican, American","Indian" ]
restaurant_drinks = ["Beer","Wine","None","Spirit, Beer, Wine, Cocktail","Beer, Wine","Beer","Spirit, Beer, Wine, Cocktail","Beer","Beer","Wine","None","Spirit, Beer, Wine","Spirit, Beer","Spirit, Beer" ]
restaurant_stars = %w[4.0 4.0 4.0 4.0 4.0 4.5 4.0 4.0 4.0 4.5 4.0 4.5 4.0 3.5]
restaurant_locations = ["Surawong","Thonglor","Sathorn","Asok","Asok","Thonglor","Asok","Silom","Surawong","Surawong","Silom","Thonglor","Ekamai","Asok" ]
restaurant_prices = %w[$ $$ $$$ $ $ $$ $$$ $$$ $ $$$$ $$$ $$ $ $]
restaurant_for_kids = %w[Yes Yes Yes Yes Yes Yes Yes Yes Yes No No Yes No Yes]
restaurant_payments = %w[Yes Yes Yes Yes No Yes Yes Yes No Yes Yes Yes No Yes]
Restaurant.all.each_with_index do |restaurant, i| 
  restaurant.restaurant_tags << RestaurantTag.find_by_title("Star:#{restaurant_stars[i]}")
  restaurant.restaurant_tags << RestaurantTag.find_by_title("Price:#{restaurant_prices[i]}")
  restaurant_cuisines[i].split(",").each do |cuisine|
    restaurant.restaurant_tags << RestaurantTag.find_by_title("Cuisine:#{cuisine.strip}")
  end
  restaurant_drinks[i].split(",").each do |drink|
    restaurant.restaurant_tags << RestaurantTag.find_by_title("Drinking:#{drink.strip}")
  end
  restaurant.restaurant_tags << RestaurantTag.find_by_title("Location:#{restaurant_locations[i]}")
  restaurant.restaurant_tags << RestaurantTag.find_by_title("Parking:Yes")
  restaurant.restaurant_tags << RestaurantTag.find_by_title("Payment:#{restaurant_payments[i]}")
  restaurant.restaurant_tags << RestaurantTag.find_by_title("Good with Kids:#{restaurant_for_kids[i]}")
end
# ==================================================================
puts "*** Restaurants created with tags***"

# Restaurant.create(name: "COCA Surawong", misc: "ซ.อนุมานราชธน ถ.สุรวงศ์ Suriyawong , Bang Rak , Bangkok", lat: 13.7282012786, lng: 100.5301216487, owner_id: Owner.first.id, days_in_advance: 1, min_booking_time: 30, res_duration: 30, largest_table: 5 )
# Photo.create(title: "sample_thumbnail", picture: File.open("app/assets/images/_restaurant_seed_5.png"), is_cover: true, restaurant_id: Restaurant.last.id) 

Restaurant.all.each do |restaurant| 
  itg1 = InventoryTemplateGroup.create(name: "Main",     restaurant: restaurant, primary: true )
  itg2 = InventoryTemplateGroup.create(name: "Weekends", restaurant: restaurant, primary: true )
         InventoryTemplateGroup.create(name: "Other",    restaurant: restaurant, primary: false )
  restaurant.update_attributes(mon: itg1.id,
                               tue: itg1.id,
                               wed: itg1.id,
                               thu: itg1.id,
                               fri: itg1.id,
                               sat: itg2.id,
                               sun: itg2.id)
end
# ==================================================================
puts "*** Inventory Template Groups created ***"

Restaurant.all.each_with_index do |restaurant, i| 
  itg_id = restaurant.inventory_template_groups.first.id
  itg_id2 = restaurant.inventory_template_groups.last.id
  itg_id3 = restaurant.inventory_template_groups.find_by_name("Weekends").id

  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 10:15:00", quantity_available: 10 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 10:15:00", end_time: "2000-01-01 10:30:00", quantity_available: 10 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 10:30:00", end_time: "2000-01-01 10:45:00", quantity_available: 10 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 10:45:00", end_time: "2000-01-01 11:00:00", quantity_available: 10 )

  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 11:00:00", end_time: "2000-01-01 11:15:00", quantity_available: 20 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 11:15:00", end_time: "2000-01-01 11:30:00", quantity_available: 20 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 11:30:00", end_time: "2000-01-01 11:45:00", quantity_available: 20 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 11:45:00", end_time: "2000-01-01 12:00:00", quantity_available: 20 )
  
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 12:00:00", end_time: "2000-01-01 12:15:00", quantity_available: 30 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 12:15:00", end_time: "2000-01-01 12:30:00", quantity_available: 30 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 12:30:00", end_time: "2000-01-01 12:45:00", quantity_available: 30 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 12:45:00", end_time: "2000-01-01 13:00:00", quantity_available: 30 )

  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 13:00:00", end_time: "2000-01-01 13:15:00", quantity_available: 100 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 13:15:00", end_time: "2000-01-01 13:30:00", quantity_available: 100 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 13:30:00", end_time: "2000-01-01 13:45:00", quantity_available: 100 )
  InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 13:45:00", end_time: "2000-01-01 14:00:00", quantity_available: 100 )
  
  InventoryTemplate.create( inventory_template_group_id: itg_id2, start_time: "2000-01-01 22:00:00", end_time: "2000-01-01 22:15:00", quantity_available: 15 )
  InventoryTemplate.create( inventory_template_group_id: itg_id2, start_time: "2000-01-01 22:15:00", end_time: "2000-01-01 22:30:00", quantity_available: 15 )
  InventoryTemplate.create( inventory_template_group_id: itg_id2, start_time: "2000-01-01 22:30:00", end_time: "2000-01-01 22:45:00", quantity_available: 15 )
  InventoryTemplate.create( inventory_template_group_id: itg_id2, start_time: "2000-01-01 22:45:00", end_time: "2000-01-01 23:00:00", quantity_available: 15 )
  InventoryTemplate.create( inventory_template_group_id: itg_id2, start_time: "2000-01-01 23:00:00", end_time: "2000-01-01 23:15:00", quantity_available: 15 )
  
  InventoryTemplate.create( inventory_template_group_id: itg_id3, start_time: "2000-01-01 18:00:00", end_time: "2000-01-01 18:15:00", quantity_available: 25 )
  InventoryTemplate.create( inventory_template_group_id: itg_id3, start_time: "2000-01-01 18:15:00", end_time: "2000-01-01 18:30:00", quantity_available: 25 )
  InventoryTemplate.create( inventory_template_group_id: itg_id3, start_time: "2000-01-01 18:30:00", end_time: "2000-01-01 18:45:00", quantity_available: 25 )
  InventoryTemplate.create( inventory_template_group_id: itg_id3, start_time: "2000-01-01 18:45:00", end_time: "2000-01-01 19:00:00", quantity_available: 25 )
end
# ==================================================================
puts "*** Inventory Templates created ***"


Restaurant.generate_schedule
# ==================================================================
puts "*** Inventories created ***"

# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 14:00:00", end_time: "2000-01-01 14:15:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 14:15:00", end_time: "2000-01-01 14:30:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 14:30:00", end_time: "2000-01-01 14:45:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 14:45:00", end_time: "2000-01-01 15:00:00", quantity_available: 10 )

# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 15:00:00", end_time: "2000-01-01 15:15:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 15:15:00", end_time: "2000-01-01 15:30:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 15:30:00", end_time: "2000-01-01 15:45:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 15:45:00", end_time: "2000-01-01 16:00:00", quantity_available: 10 )

# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 16:00:00", end_time: "2000-01-01 16:15:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 16:15:00", end_time: "2000-01-01 16:30:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 16:30:00", end_time: "2000-01-01 16:45:00", quantity_available: 10 )
# InventoryTemplate.create( inventory_template_group_id: itg_id, start_time: "2000-01-01 16:45:00", end_time: "2000-01-01 17:00:00", quantity_available: 10 )

# Inventory.create(date: Time.zone.now.to_date, quantity_available: 10, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 17:00:00", restaurant_id: Restaurant.first.id)
# Inventory.create(date: Time.zone.now.tomorrow.to_date, quantity_available: 10, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 17:00:00",restaurant_id: Restaurant.first.id)

User.delete_all
User.create(email: "user1@mail.com", password: "secret12", username: "sample user 1", phone: "0213456789")
User.create(email: "user2@mail.com", password: "secret12", username: "sample user 2", phone: "0223456789")
User.create(email: "waqar@mail.com", password: "secret12", username: "waqar's user", phone: "0123456789")
# ==================================================================
puts "*** Users created ***"

Reservation.delete_all
# User.all.each_with_index do |u, i| 
  # Restaurant.all.each do |restaurant| 
  # Reservation.create( user_id: u.id, 
  #                     restaurant_id: Restaurant.first.id, 
  #                     date: Time.zone.now.to_date, 
  #                     start_time: "2000-01-01 13:30:00", 
  #                     end_time: "2000-01-01 15:00:00", 
  #                     party_size: 10, 
  #                     active: true )
  # end
# end
u1 = User.first
u2 = User.last
Reservation.create( user_id: u1.id, 
                    restaurant_id: Restaurant.first.id, 
                    date: Time.zone.now.to_date, 
                    start_time: "2000-01-01 11:00:00", 
                    end_time: "2000-01-01 12:30:00", 
                    party_size: 12, active: true )
Reservation.create( user_id: u1.id, 
                    restaurant_id: Restaurant.first.id, 
                    date: Time.zone.now.tomorrow.to_date, 
                    start_time: "2000-01-01 11:00:00", 
                    end_time: "2000-01-01 12:30:00", 
                    party_size: 12, active: true )
Reservation.create( user_id: u1.id, 
                    restaurant_id: Restaurant.last.id, 
                    date: Time.zone.now.to_date, 
                    start_time: "2000-01-01 11:00:00", 
                    end_time: "2000-01-01 12:30:00", 
                    party_size: 12, active: false )
Reservation.create( user_id: u1.id, 
                    restaurant_id: Restaurant.last.id, 
                    date: Time.zone.now.tomorrow.to_date, 
                    start_time: "2000-01-01 11:00:00", 
                    end_time: "2000-01-01 12:30:00", 
                    party_size: 12, active: false )
# u2
Reservation.create( user_id: u2.id, 
                    restaurant_id: Restaurant.first.id, 
                    date: Time.zone.now.to_date, 
                    start_time: "2000-01-01 09:00:00", 
                    end_time: "2000-01-01 10:30:00", 
                    party_size: 12, active: true )
Reservation.create( user_id: u2.id, 
                    restaurant_id: Restaurant.first.id, 
                    date: Time.zone.now.tomorrow.to_date, 
                    start_time: "2000-01-01 09:00:00", 
                    end_time: "2000-01-01 10:30:00", 
                    party_size: 12, active: false )
Reservation.create( user_id: u2.id, 
                    restaurant_id: Restaurant.last.id, 
                    date: Time.zone.now.to_date, 
                    start_time: "2000-01-01 09:00:00", 
                    end_time: "2000-01-01 10:30:00", 
                    party_size: 12, active: true )
Reservation.create( user_id: u2.id, 
                    restaurant_id: Restaurant.last.id, 
                    date: Time.zone.now.tomorrow.to_date, 
                    start_time: "2000-01-01 09:00:00", 
                    end_time: "2000-01-01 10:30:00", 
                    party_size: 12, active: false )
# Manual reservations (owner's)
Reservation.create(restaurant_id: Restaurant.first.id, date: Time.zone.now.to_date, start_time: "2000-01-01 14:00:00", end_time: "2000-01-01 15:00:00", party_size: 2, active: false, name: "Sample-Name1", email: "mail_1@mail.com", phone: "+646654646", owner_id: Restaurant.first.owner.id)
Reservation.create(restaurant_id: Restaurant.last.id,  date: Time.zone.now.tomorrow.to_date, start_time: "2000-01-01 14:00:00", end_time: "2000-01-01 15:00:00", party_size: 2, active: true, name: "Sample-Name2", email: "mail_2@mail.com", phone: "+646622246", owner_id: Restaurant.last.owner.id)
# ==================================================================
puts "*** Reservations created ***"

# Reservation.create(user_id: User.first.id, restaurant_id: Restaurant.first.id, date: Time.zone.now.tomorrow.to_date, start_time: "2000-01-01 11:00:00", end_time: "2000-01-01 12:30:00", party_size: 10, active: false )
# Reservation.create(user_id: User.first.id, restaurant_id: Restaurant.last.id, date: "2013-11-01", start_time: "2000-01-01 16:00:00", end_time: "2000-01-01 16:45:00", party_size: 4, active: true )
# Reservation.create(user_id: User.last.id, restaurant_id: Restaurant.last.id, date: "2013-11-02", start_time: "2000-01-01 14:00:00", end_time: "2000-01-01 14:30:00", party_size: 3, active: true )
# Reservation.create(user_id: User.last.id, restaurant_id: Restaurant.last.id, date: "2013-11-12", start_time: "2000-01-01 15:00:00", end_time: "2000-01-01 15:30:00", party_size: 1, active: true )