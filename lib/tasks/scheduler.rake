desc "This task is called by the Heroku scheduler add-on"
task :inv_create => :environment do
  puts "---------------------------------"
  puts "   Starting inventories generation"
  Restaurant.generate_schedule
  puts "---------------------------------"
  puts "   done."
end

task :rewards_points_update => :environment do
  puts "---------------------------------"
  puts "   Starting updating points pending in rewards"
  Reward.set_points_pending
  puts "---------------------------------"
  puts "   done."
end