# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CuisineTag.delete_all
cuisines = %w[Any American Bar Barbeque Breakfast Chinese French Fusion Grill Hotel Italian Rooftop Pub Shabu Sukiyaki]  
cuisines.each {|c| CuisineTag.create(title: c)}
