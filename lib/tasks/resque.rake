require "resque/tasks"  
require 'resque/scheduler/tasks'

task "resque:setup" => :environment

# load the Rails app all the time
# namespace :resque do
#   puts "Loading Rails environment for Resque"
#   task :setup => :environment do
#     ActiveRecord::Base.descendants.each { |klass|  klass.columns }
#   end
# end