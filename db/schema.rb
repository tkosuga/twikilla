# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100820072504) do

  create_table "bots", :force => true do |t|
    t.integer  "customer_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bots", ["customer_id"], :name => "index_bots_on_customer_id"

  create_table "customers", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["user_id"], :name => "index_customers_on_user_id", :unique => true

  create_table "is_spammer_applications", :force => true do |t|
    t.integer  "spammer_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "is_spammer_applications", ["spammer_id"], :name => "index_is_spammer_applications_on_spammer_id"
  add_index "is_spammer_applications", ["user_id"], :name => "index_is_spammer_applications_on_user_id"

  create_table "isnt_spammer_applications", :force => true do |t|
    t.integer  "spammer_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "isnt_spammer_applications", ["spammer_id"], :name => "index_isnt_spammer_applications_on_spammer_id"
  add_index "isnt_spammer_applications", ["user_id"], :name => "index_isnt_spammer_applications_on_user_id"

  create_table "spammers", :force => true do |t|
    t.integer  "user_id",                                        :null => false
    t.string   "user",                                           :null => false
    t.string   "profile_image_url"
    t.integer  "hashtag_spam_count",          :default => 0,     :null => false
    t.integer  "followers_count",             :default => 0,     :null => false
    t.integer  "friends_count",               :default => 0,     :null => false
    t.string   "iso_language_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hashed_tag_spammer",          :default => false, :null => false
    t.boolean  "automated_following_spammer", :default => false, :null => false
    t.boolean  "ask_retweet_spammer",         :default => false, :null => false
    t.boolean  "isnt_spammer",                :default => false, :null => false
    t.boolean  "follow7com_spammer",          :default => false, :null => false
    t.boolean  "rt_spammer",                  :default => false, :null => false
  end

  add_index "spammers", ["ask_retweet_spammer"], :name => "index_spammers_on_ask_retweet_spammer"
  add_index "spammers", ["automated_following_spammer"], :name => "index_spammers_on_automated_following_spammer"
  add_index "spammers", ["follow7com_spammer"], :name => "index_spammers_on_follow7com_spammer"
  add_index "spammers", ["hashed_tag_spammer"], :name => "index_spammers_on_hashed_tag_spammer"
  add_index "spammers", ["isnt_spammer"], :name => "index_spammers_on_isnt_spammer"
  add_index "spammers", ["iso_language_code"], :name => "index_users_on_iso_language_code"
  add_index "spammers", ["rt_spammer"], :name => "index_spammers_on_rt_spammer"
  add_index "spammers", ["user"], :name => "index_users_on_user", :unique => true
  add_index "spammers", ["user_id"], :name => "index_users_on_user_id", :unique => true

end
