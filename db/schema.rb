# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140820195214) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "inventories", :force => true do |t|
    t.integer  "restaurant_id"
    t.date     "date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "quantity_available"
  end

  add_index "inventories", ["restaurant_id"], :name => "index_inventories_on_restaurant_id"

  create_table "inventory_template_groups", :force => true do |t|
    t.string   "name"
    t.boolean  "primary"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "inventory_template_groups", ["restaurant_id"], :name => "index_inventory_template_groups_on_restaurant_id"

  create_table "inventory_templates", :force => true do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "quantity_available"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "inventory_template_group_id"
  end

  create_table "nicknames", :force => true do |t|
    t.string  "nickname"
    t.integer "user_id"
    t.integer "restaurant_id"
    t.string  "phone"
  end

  add_index "nicknames", ["restaurant_id"], :name => "index_nicknames_on_restaurant_id"
  add_index "nicknames", ["user_id"], :name => "index_nicknames_on_user_id"

  create_table "notes", :force => true do |t|
    t.integer "user_id"
    t.integer "restaurant_id"
    t.string  "phone"
    t.text    "note"
  end

  add_index "notes", ["restaurant_id"], :name => "index_notes_on_restaurant_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "owners", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "owner_name"
    t.string   "phone"
  end

  add_index "owners", ["email"], :name => "index_owners_on_email", :unique => true
  add_index "owners", ["reset_password_token"], :name => "index_owners_on_reset_password_token", :unique => true

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.string   "picture"
    t.integer  "restaurant_id"
    t.boolean  "is_cover"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "reservations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "party_size"
    t.boolean  "active"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "owner_id"
    t.boolean  "no_show",         :default => false, :null => false
    t.boolean  "arrived",         :default => false, :null => false
    t.text     "table"
    t.text     "special_request"
    t.integer  "channel",         :default => 0
  end

  add_index "reservations", ["restaurant_id"], :name => "index_reservations_on_restaurant_id"
  add_index "reservations", ["user_id"], :name => "index_reservations_on_user_id"

  create_table "restaurant_tags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "restaurant_tags_restaurants", :id => false, :force => true do |t|
    t.integer "restaurant_tag_id"
    t.integer "restaurant_id"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.text     "misc"
    t.decimal  "lat",                       :precision => 15, :scale => 10
    t.decimal  "lng",                       :precision => 15, :scale => 10
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "owner_id"
    t.integer  "days_in_advance"
    t.integer  "min_booking_time"
    t.integer  "res_duration"
    t.integer  "largest_table"
    t.integer  "mon"
    t.integer  "tue"
    t.integer  "wed"
    t.integer  "thu"
    t.integer  "fri"
    t.integer  "sat"
    t.integer  "sun"
    t.string   "phone"
    t.string   "website"
    t.string   "address"
    t.integer  "est_duration"
    t.integer  "est_duration_confidence"
    t.string   "th_address"
    t.string   "days_out_allow_booking"
    t.string   "min_in_adv_bookings_close"
    t.string   "avg_turn_time"
    t.string   "conf_in_avg_turn_time"
    t.string   "max_turn_time"
    t.boolean  "active",                                                    :default => true, :null => false
    t.text     "th_misc"
  end

  create_table "rewards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reservation_id"
    t.integer  "points_total"
    t.integer  "points_pending"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "restaurant_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "uid"
    t.string   "provider"
    t.string   "username"
    t.string   "phone"
    t.string   "authentication_token"
    t.integer  "verify_code"
    t.boolean  "verified",               :default => false, :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vips", :force => true do |t|
    t.integer "user_id"
    t.integer "restaurant_id"
    t.string  "name"
    t.string  "phone"
  end

  add_index "vips", ["restaurant_id"], :name => "index_vips_on_restaurant_id"
  add_index "vips", ["user_id"], :name => "index_vips_on_user_id"

end
