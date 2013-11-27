desc "This task is called by the Heroku scheduler add-on"
task :inv_create => :environment do
  puts "Starting auto inventories creation"
  Restaurant.generate_schedule
  puts "done."
end