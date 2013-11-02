# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
#
# Learn more: http://github.com/javan/whenever

# set :environment, :development
# set :output, '~/GIT/1/booking-master-with-clear-bs3/tmp/whenever.log'

# # every 1.day, :at => '3:00 am' do
# every 1.minute do
#   # command "echo 'one' && echo 'two'"
#   runner "Restaurant.generate_schedule"
# end