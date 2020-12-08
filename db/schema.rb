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

ActiveRecord::Schema.define(:version => 20140714235920) do

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "contact_name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "email"
    t.string   "icq"
    t.string   "skype"
    t.string   "mailru"
    t.string   "site"
    t.integer  "city_firm_id"
    t.text     "explanation"
    t.string   "vk"
    t.string   "mobile_phone"
    t.boolean  "coordinates",        :default => false
    t.time     "working_time_start"
    t.time     "working_time_end"
    t.integer  "position"
    t.string   "location"
  end

  add_index "addresses", ["city_firm_id"], :name => "index_addresses_on_city_firm_id"
  add_index "addresses", ["position"], :name => "index_addresses_on_position"

  create_table "admin_photos", :force => true do |t|
    t.string   "path"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "avatars", :force => true do |t|
    t.integer "client_id"
  end

  create_table "background_properties", :force => true do |t|
    t.string   "title"
    t.string   "color"
    t.string   "image"
    t.string   "attachment"
    t.string   "position"
    t.string   "repeat"
    t.boolean  "is_active",         :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "sites_count",       :default => 0
    t.boolean  "header",            :default => false
    t.boolean  "general",           :default => false
    t.string   "header_color",      :default => "#4D4D4D"
    t.string   "header_date_color", :default => "#C84563"
    t.integer  "firms_count",       :default => 0
  end

  add_index "background_properties", ["header", "firms_count"], :name => "index_header_and_firms_count"
  add_index "background_properties", ["header", "sites_count"], :name => "index_header_and_sites_count"
  add_index "background_properties", ["header"], :name => "index_background_properties_on_header"

  create_table "banners", :force => true do |t|
    t.string   "image"
    t.string   "title"
    t.string   "link"
    t.text     "description"
    t.boolean  "for_guests"
    t.boolean  "for_users"
    t.boolean  "for_firms"
    t.integer  "banner_type", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "bonus_certificates", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "payment_id"
    t.integer  "service_id"
    t.string   "name"
    t.text     "description"
    t.date     "starts_at"
    t.date     "ends_at"
    t.datetime "deleted_at"
    t.integer  "amount_cents"
    t.integer  "quantity",      :default => 1
    t.integer  "used_quantity", :default => 0
    t.integer  "limit",         :default => 1
    t.string   "number"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "bonus_certificates", ["ends_at"], :name => "index_bonus_certificates_on_ends_at"
  add_index "bonus_certificates", ["owner_id", "owner_type"], :name => "bonus_promotions_owner_index"
  add_index "bonus_certificates", ["payment_id"], :name => "index_bonus_certificates_on_payment_id"
  add_index "bonus_certificates", ["service_id"], :name => "index_bonus_certificates_on_service_id"
  add_index "bonus_certificates", ["starts_at"], :name => "index_bonus_certificates_on_starts_at"

  create_table "bonus_city_dealer_percents", :force => true do |t|
    t.integer  "service_id"
    t.integer  "city_id"
    t.integer  "percent"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bonus_city_dealer_percents", ["city_id"], :name => "index_bonus_city_dealer_percents_on_city_id"
  add_index "bonus_city_dealer_percents", ["service_id"], :name => "index_bonus_city_dealer_percents_on_service_id"

  create_table "bonus_city_ratios", :force => true do |t|
    t.integer  "service_id"
    t.integer  "city_id"
    t.integer  "percent",    :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "bonus_city_ratios", ["city_id"], :name => "index_bonus_city_ratios_on_city_id"
  add_index "bonus_city_ratios", ["service_id"], :name => "index_bonus_city_ratios_on_service_id"

  create_table "bonus_loyalties", :force => true do |t|
    t.integer  "service_id"
    t.integer  "years_count"
    t.integer  "discount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "bonus_loyalties", ["service_id"], :name => "index_bonus_loyalties_on_service_id"

  create_table "bonus_packages", :force => true do |t|
    t.integer  "service_id"
    t.integer  "months_count"
    t.integer  "percent",      :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "bonus_packages", ["service_id"], :name => "index_bonus_packages_on_service_id"

  create_table "bonus_prices", :force => true do |t|
    t.integer  "service_id"
    t.integer  "firm_catalog_id"
    t.integer  "amount_cents",    :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "bonus_prices", ["firm_catalog_id"], :name => "index_bonus_prices_on_firm_catalog_id"
  add_index "bonus_prices", ["service_id"], :name => "index_bonus_prices_on_service_id"

  create_table "bonus_reward_transfers", :force => true do |t|
    t.integer  "dealer_id"
    t.integer  "payer_id"
    t.integer  "amount_cents"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "bonus_reward_transfers", ["dealer_id"], :name => "index_bonus_reward_transfers_on_dealer_id"
  add_index "bonus_reward_transfers", ["payer_id"], :name => "index_bonus_reward_transfers_on_payer_id"

  create_table "bonus_rewards", :force => true do |t|
    t.integer  "payment_id"
    t.string   "payment_type"
    t.integer  "referral_id"
    t.integer  "dealer_id"
    t.integer  "amount_cents"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "bonus_rewards", ["dealer_id"], :name => "index_bonus_rewards_on_dealer_id"
  add_index "bonus_rewards", ["payment_id", "payment_type"], :name => "bonus_rewards_payment_index"
  add_index "bonus_rewards", ["referral_id"], :name => "index_bonus_rewards_on_referral_id"

  create_table "bonus_seasonal_factors", :force => true do |t|
    t.integer  "service_id"
    t.integer  "month"
    t.integer  "discount",   :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "bonus_seasonal_factors", ["service_id"], :name => "index_bonus_seasonal_factors_on_service_id"

  create_table "bonus_services", :force => true do |t|
    t.string   "identifier"
    t.string   "slug"
    t.string   "type"
    t.string   "state"
    t.integer  "position"
    t.string   "name"
    t.text     "description"
    t.integer  "amount_cents",   :default => 0
    t.integer  "discount",       :default => 0
    t.integer  "dealer_percent", :default => 0
    t.boolean  "pay_once",       :default => false
    t.integer  "trial_duration", :default => 0
    t.boolean  "list",           :default => true
    t.datetime "deleted_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "bonus_services", ["deleted_at"], :name => "index_bonus_services_on_deleted_at"
  add_index "bonus_services", ["identifier"], :name => "index_bonus_services_on_identifier"
  add_index "bonus_services", ["list"], :name => "index_bonus_services_on_list"
  add_index "bonus_services", ["position"], :name => "index_bonus_services_on_position"
  add_index "bonus_services", ["slug"], :name => "index_bonus_services_on_slug"
  add_index "bonus_services", ["state"], :name => "index_bonus_services_on_state"
  add_index "bonus_services", ["type"], :name => "index_bonus_services_on_type"

  create_table "bonus_signing_services", :force => true do |t|
    t.integer  "service_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.date     "starts_at"
    t.date     "ends_at"
    t.date     "loyalty_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "bonus_signing_services", ["service_id"], :name => "index_bonus_signing_services_on_service_id"
  add_index "bonus_signing_services", ["target_id", "target_type"], :name => "bonus_signing_services_target_index"

  create_table "bonus_subscriptions", :force => true do |t|
    t.integer  "service_id"
    t.integer  "user_id"
    t.integer  "package_id"
    t.integer  "payer_id"
    t.integer  "signing_service_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "signing_object_id"
    t.string   "signing_object_type"
    t.integer  "payment_id"
    t.string   "payment_type"
    t.integer  "amount_cents"
    t.date     "starts_at"
    t.date     "ends_at"
    t.string   "state"
    t.boolean  "pay_once"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "payer_type",          :default => "User"
    t.integer  "certificate_id"
  end

  add_index "bonus_subscriptions", ["certificate_id"], :name => "index_bonus_subscriptions_on_certificate_id"
  add_index "bonus_subscriptions", ["package_id"], :name => "index_bonus_subscriptions_on_package_id"
  add_index "bonus_subscriptions", ["payer_id", "payer_type"], :name => "bonus_subscriptions_payer_index"
  add_index "bonus_subscriptions", ["payer_id"], :name => "index_bonus_subscriptions_on_payer_id"
  add_index "bonus_subscriptions", ["payment_id", "payment_type"], :name => "bonus_subscriptions_payment_index"
  add_index "bonus_subscriptions", ["service_id"], :name => "index_bonus_subscriptions_on_service_id"
  add_index "bonus_subscriptions", ["signing_object_id", "signing_object_type"], :name => "bonus_subscriptions_signing_object_index"
  add_index "bonus_subscriptions", ["signing_service_id"], :name => "index_bonus_subscriptions_on_signing_service_id"
  add_index "bonus_subscriptions", ["state"], :name => "index_bonus_subscriptions_on_state"
  add_index "bonus_subscriptions", ["target_id", "target_type"], :name => "bonus_subscriptions_target_index"
  add_index "bonus_subscriptions", ["user_id"], :name => "index_bonus_subscriptions_on_user_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "geoip_id"
    t.boolean  "enabled_for_firms", :default => false, :null => false
    t.boolean  "wedding_city",      :default => false
    t.string   "slug"
  end

  add_index "cities", ["geoip_id"], :name => "index_cities_on_geoip_id", :unique => true
  add_index "cities", ["latitude", "longitude"], :name => "index_cities_on_latitude_and_longitude"
  add_index "cities", ["region_id"], :name => "index_cities_on_region_id"
  add_index "cities", ["slug"], :name => "index_cities_on_slug", :unique => true

  create_table "city_firms", :force => true do |t|
    t.integer  "city_id"
    t.integer  "firm_id"
    t.boolean  "base",       :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "rating"
    t.integer  "dealer_id"
    t.datetime "deleted_at"
  end

  add_index "city_firms", ["city_id"], :name => "index_city_firms_on_city_id"
  add_index "city_firms", ["dealer_id"], :name => "index_city_firms_on_dealer_id"
  add_index "city_firms", ["firm_id"], :name => "index_city_firms_on_firm_id"

  create_table "clients", :force => true do |t|
    t.integer  "couple_id"
    t.date     "birthday"
    t.integer  "wedding_id"
    t.integer  "type_user"
    t.boolean  "gender"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "city_id"
    t.integer  "friends_count"
    t.string   "text_status"
    t.integer  "site_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "description"
    t.string   "slug"
    t.string   "avatar"
    t.text     "activities"
    t.text     "interests"
    t.text     "favorite_music"
    t.text     "favorite_films"
    t.text     "favorite_shows"
    t.text     "favorite_books"
    t.text     "favorite_games"
    t.text     "favorite_quotes"
    t.text     "about"
    t.integer  "wedding_city_id"
    t.string   "visibility"
    t.integer  "country_id"
    t.string   "children"
    t.string   "string"
    t.string   "alcohol_attitude"
    t.string   "smoking_attitude"
    t.string   "thing_in_life"
    t.string   "thing_in_humans"
    t.string   "marital_status"
    t.integer  "cached_votes_up",  :default => 0
    t.datetime "visited_at"
    t.datetime "deleted_at"
  end

  add_index "clients", ["cached_votes_up"], :name => "index_clients_on_cached_votes_up"
  add_index "clients", ["slug"], :name => "index_clients_on_slug"
  add_index "clients", ["wedding_city_id"], :name => "index_clients_on_wedding_city_id"

  create_table "clients_communities", :id => false, :force => true do |t|
    t.integer "community_id"
    t.integer "client_id"
  end

  create_table "color_tags", :force => true do |t|
    t.string "name"
    t.string "color"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.datetime "deleted_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "communities", :force => true do |t|
    t.string   "avatar"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "community_category_id"
    t.text     "rules"
    t.string   "logo"
    t.integer  "position"
  end

  add_index "communities", ["community_category_id"], :name => "index_communities_on_community_category_id"

  create_table "community_categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "avatar"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "position"
  end

  create_table "community_post_categories", :force => true do |t|
    t.integer  "community_id"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "community_post_categories", ["community_id"], :name => "index_community_post_categories_on_community_id"

  create_table "companies", :force => true do |t|
    t.string "brand",         :null => false
    t.string "inn",           :null => false
    t.string "ogrn",          :null => false
    t.string "legal_address", :null => false
    t.string "bank",          :null => false
    t.string "bik",           :null => false
    t.string "rs",            :null => false
    t.string "ks",            :null => false
  end

  create_table "competition_prizes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "picture"
    t.integer  "competition_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "competition_prizes", ["competition_id"], :name => "index_competition_prizes_on_competition_id"

  create_table "competitions", :force => true do |t|
    t.integer  "firm_id"
    t.string   "name"
    t.string   "banner"
    t.text     "about_competition"
    t.text     "rules"
    t.date     "start_date"
    t.date     "deadline_date"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "competitions", ["firm_id"], :name => "index_competitions_on_firm_id"

  create_table "complaints", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pretension_id"
    t.string   "pretension_type"
    t.text     "content"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "complaints", ["pretension_id", "pretension_type"], :name => "index_complaints_on_pretension_id_and_pretension_type"
  add_index "complaints", ["user_id"], :name => "index_complaints_on_user_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "code",        :limit => 2
    t.string   "iso_numeric"
  end

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

  create_table "event_categories", :force => true do |t|
    t.integer  "event_type_id"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "event_categories", ["event_type_id"], :name => "index_event_categories_on_event_type_id"

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "date_to"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "task_id"
    t.integer  "timetable_id"
    t.integer  "firm_catalog_id"
    t.integer  "firm_id"
    t.string   "type_task"
    t.integer  "task_category_id"
    t.string   "custom_firm"
    t.string   "service"
    t.string   "aasm_state"
    t.integer  "wedding_id"
  end

  add_index "events", ["task_category_id"], :name => "index_events_on_task_category_id"
  add_index "events", ["timetable_id"], :name => "index_events_on_timetable_id"

  create_table "events_firms", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "firm_id"
  end

  add_index "events_firms", ["event_id"], :name => "index_events_firms_on_event_id"
  add_index "events_firms", ["firm_id"], :name => "index_events_firms_on_firm_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "favoriteable_id"
    t.string   "favoriteable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "favorites", ["favoriteable_id", "favoriteable_type"], :name => "index_favorites_on_favoriteable_id_and_favoriteable_type"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "firm_catalog_tasks", :force => true do |t|
    t.integer  "task_id"
    t.integer  "firm_catalog_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "firm_catalog_tasks", ["firm_catalog_id"], :name => "index_firm_catalog_tasks_on_firm_catalog_id"
  add_index "firm_catalog_tasks", ["task_id"], :name => "index_firm_catalog_tasks_on_task_id"

  create_table "firm_catalogs", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "children_count"
    t.string  "logo"
    t.string  "extended_name",  :default => ""
    t.string  "category"
    t.string  "slug"
  end

  add_index "firm_catalogs", ["category"], :name => "index_firm_catalogs_on_category"
  add_index "firm_catalogs", ["slug"], :name => "index_firm_catalogs_on_slug", :unique => true

  create_table "firm_catalogs_firms", :id => false, :force => true do |t|
    t.integer "firm_id"
    t.integer "firm_catalog_id"
  end

  create_table "firm_pages", :force => true do |t|
    t.integer  "firm_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "firm_services", :force => true do |t|
    t.integer  "firm_id"
    t.string   "name"
    t.string   "unit"
    t.string   "cost"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "raiting",    :default => 0, :null => false
  end

  add_index "firm_services", ["firm_id"], :name => "index_firm_services_on_firm_id"

  create_table "firms", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.text     "description"
    t.string   "status"
    t.integer  "balance",                   :default => 0,     :null => false
    t.string   "skype"
    t.string   "website"
    t.integer  "business_id"
    t.string   "business_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text_status"
    t.integer  "city_id"
    t.boolean  "ready",                     :default => false, :null => false
    t.string   "extended_name"
    t.integer  "banner_album_id"
    t.integer  "base_sphere_id"
    t.string   "slug"
    t.integer  "card_service_id"
    t.integer  "detail_page_id"
    t.integer  "business_card_left_block",  :default => 0
    t.integer  "business_card_right_block", :default => 0
    t.integer  "wedding_city_id"
    t.integer  "parent_id"
    t.string   "invite_token"
    t.date     "bonus_pro_at"
    t.date     "bonus_vip_at"
    t.date     "bonus_color_at"
    t.datetime "bonus_high_in_at"
    t.integer  "bonus_status",              :default => 0
    t.datetime "deleted_at"
    t.integer  "background_image_id"
    t.string   "background_picture"
  end

  add_index "firms", ["bonus_color_at"], :name => "index_firms_on_bonus_color_at"
  add_index "firms", ["bonus_high_in_at"], :name => "index_firms_on_bonus_high_in_at"
  add_index "firms", ["bonus_pro_at"], :name => "index_firms_on_bonus_pro_at"
  add_index "firms", ["bonus_status"], :name => "index_firms_on_bonus_status"
  add_index "firms", ["bonus_vip_at"], :name => "index_firms_on_bonus_vip_at"
  add_index "firms", ["city_id"], :name => "index_firms_on_city_id"
  add_index "firms", ["invite_token"], :name => "index_firms_on_invite_token"
  add_index "firms", ["parent_id"], :name => "index_firms_on_parent_id"
  add_index "firms", ["slug"], :name => "index_firms_on_slug"
  add_index "firms", ["wedding_city_id"], :name => "index_firms_on_wedding_city_id"

  create_table "firms_users", :id => false, :force => true do |t|
    t.integer "firm_id"
    t.integer "user_id"
  end

  add_index "firms_users", ["firm_id", "user_id"], :name => "index_firms_users_on_firm_id_and_user_id", :unique => true

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "friendship_message_id"
    t.datetime "requested_at"
    t.datetime "accepted_at"
    t.string   "status"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["status"], :name => "index_friendships_on_status"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "guestbooks", :force => true do |t|
    t.integer  "site_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "guestbooks", ["site_id"], :name => "index_guestbooks_on_site_id"

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.boolean  "gender",                  :default => false
    t.string   "email"
    t.integer  "drink",      :limit => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "site_id"
    t.string   "group"
    t.boolean  "dowry"
    t.boolean  "ceremony"
    t.boolean  "banquet"
    t.integer  "user_id"
    t.integer  "position"
  end

  add_index "guests", ["banquet"], :name => "index_guests_on_banquet"
  add_index "guests", ["group", "user_id"], :name => "index_guests_on_group_and_user_id"
  add_index "guests", ["position"], :name => "index_guests_on_position"
  add_index "guests", ["site_id"], :name => "index_guests_on_site_id"
  add_index "guests", ["user_id"], :name => "index_guests_on_user_id"

  create_table "icons", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "idea_categories", :force => true do |t|
    t.string   "name",                         :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "width",         :default => 0, :null => false
    t.integer  "height",        :default => 0, :null => false
    t.string   "image"
    t.text     "description"
    t.integer  "collection_id"
    t.integer  "position",      :default => 0
    t.string   "slug"
  end

  add_index "idea_categories", ["slug"], :name => "index_idea_categories_on_slug", :unique => true

  create_table "idea_categories_ideas", :id => false, :force => true do |t|
    t.integer "idea_category_id"
    t.integer "idea_id"
  end

  create_table "idea_categories_sections", :force => true do |t|
    t.integer "category_id"
    t.integer "section_id"
  end

  create_table "idea_category_tasks", :force => true do |t|
    t.integer  "task_id"
    t.integer  "category_id"
    t.integer  "section_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "idea_category_tasks", ["category_id"], :name => "index_idea_category_tasks_on_idea_category_id"
  add_index "idea_category_tasks", ["section_id"], :name => "index_idea_category_tasks_on_idea_section_id"
  add_index "idea_category_tasks", ["section_id"], :name => "index_idea_category_tasks_on_wedding_idea_section_id"
  add_index "idea_category_tasks", ["task_id"], :name => "index_idea_category_tasks_on_task_id"

  create_table "idea_collections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "idea_ideas", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "ready",         :default => false, :null => false
    t.string   "name"
    t.integer  "collection_id"
  end

  create_table "idea_sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "image"
    t.text     "description"
    t.integer  "position",    :default => 0
    t.string   "slug"
  end

  add_index "idea_sections", ["slug"], :name => "index_idea_sections_on_slug", :unique => true

  create_table "idea_user_ideas", :force => true do |t|
    t.integer "user_id",                        :null => false
    t.integer "idea_id",                        :null => false
    t.integer "category_id",                    :null => false
    t.boolean "cover",       :default => false, :null => false
  end

  add_index "idea_user_ideas", ["category_id"], :name => "index_user_ideas_on_idea_category_id"
  add_index "idea_user_ideas", ["idea_id"], :name => "index_user_ideas_on_idea_id"
  add_index "idea_user_ideas", ["user_id"], :name => "index_user_ideas_on_user_id"

  create_table "ies", :force => true do |t|
    t.string "brand",         :null => false
    t.string "inn",           :null => false
    t.string "ogrnip",        :null => false
    t.string "legal_address", :null => false
    t.string "bank"
    t.string "bik"
    t.string "rs"
    t.string "ks"
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "image"
    t.string   "type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "cached_votes_up", :default => 0
  end

  add_index "images", ["cached_votes_up"], :name => "index_images_on_cached_votes_up"
  add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"
  add_index "images", ["type"], :name => "index_images_on_type"

  create_table "ip_ranges", :force => true do |t|
    t.integer "range_start", :limit => 8, :null => false
    t.integer "range_end",   :limit => 8, :null => false
    t.string  "range"
    t.integer "city_id"
    t.integer "country_id"
  end

  add_index "ip_ranges", ["range_start", "range_end"], :name => "index_ip_ranges_on_range_start_and_range_end"

  create_table "mail_templates", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.date     "send_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "media_contents", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "content"
    t.boolean  "video"
    t.integer  "multimedia_id"
    t.string   "multimedia_type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "status",          :default => 0, :null => false
    t.integer  "cached_votes_up", :default => 0
    t.integer  "views",           :default => 0
    t.string   "media_preview"
    t.string   "duration"
  end

  add_index "media_contents", ["cached_votes_up"], :name => "index_media_contents_on_cached_votes_up"
  add_index "media_contents", ["multimedia_type", "multimedia_id"], :name => "index_media_contents_on_multimedia_type_and_multimedia_id"

  create_table "message_rooms", :force => true do |t|
    t.integer  "message_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "message_rooms_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "message_room_id"
  end

  add_index "message_rooms_users", ["message_room_id"], :name => "index_message_rooms_users_on_message_room_id"
  add_index "message_rooms_users", ["user_id"], :name => "index_message_rooms_users_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.boolean  "read",            :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "message_room_id"
  end

  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "old_seating_plans", :force => true do |t|
    t.text     "tables"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "site_id"
  end

  add_index "old_seating_plans", ["site_id"], :name => "index_site_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.boolean  "system",     :default => false, :null => false
    t.boolean  "active",     :default => true,  :null => false
    t.integer  "site_id"
    t.boolean  "main",       :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "hidden",     :default => false, :null => false
  end

  add_index "pages", ["name", "site_id"], :name => "index_pages_on_name_and_site_id", :unique => true

  create_table "payments", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "amount_cents",        :default => 0,     :null => false
    t.string   "currency",            :default => "RUB"
    t.string   "token"
    t.string   "identifier"
    t.string   "payer_id"
    t.string   "state"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "refund_amount_cents", :default => 0
  end

  add_index "payments", ["currency"], :name => "index_payments_on_currency"
  add_index "payments", ["identifier"], :name => "index_payments_on_identifier"
  add_index "payments", ["state"], :name => "index_payments_on_state"
  add_index "payments", ["type"], :name => "index_payments_on_type"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "phone_numbers", :force => true do |t|
    t.string   "phone"
    t.integer  "address_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phone_numbers", ["address_id"], :name => "index_phone_numbers_on_address_id"

  create_table "photo_albums", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "cover"
    t.integer  "count",           :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "cover_id"
    t.text     "description"
    t.integer  "system",          :default => 0
    t.integer  "cached_votes_up", :default => 0
    t.integer  "photos_count",    :default => 0
  end

  add_index "photo_albums", ["cached_votes_up"], :name => "index_photo_albums_on_cached_votes_up"
  add_index "photo_albums", ["cover_id"], :name => "index_photo_albums_on_cover_id"
  add_index "photo_albums", ["photos_count"], :name => "index_photo_albums_on_photos_count"

  create_table "photos", :force => true do |t|
    t.integer  "photo_album_id"
    t.string   "usual_path"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "banner_path"
    t.integer  "initial_album_id"
    t.string   "title"
    t.string   "link"
  end

  add_index "photos", ["photo_album_id"], :name => "index_photos_on_photo_album_id"

  create_table "plans", :force => true do |t|
    t.integer  "script_id"
    t.string   "plan_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "index_number"
    t.text     "description"
  end

  add_index "plans", ["script_id"], :name => "index_plans_on_script_id"

  create_table "plans_tasks", :id => false, :force => true do |t|
    t.integer "plan_id"
    t.integer "task_id"
  end

  add_index "plans_tasks", ["plan_id", "task_id"], :name => "index_plans_tasks_on_plan_id_and_task_id"

  create_table "poll_tmp_images", :force => true do |t|
    t.string   "image",      :null => false
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "client_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "body",            :default => ""
    t.integer  "journal_id"
    t.string   "journal_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "title"
    t.integer  "status",          :default => 0,  :null => false
    t.integer  "cached_votes_up", :default => 0
    t.integer  "views",           :default => 0
    t.integer  "category_id"
    t.datetime "last_comment_at"
  end

  add_index "posts", ["cached_votes_up"], :name => "index_posts_on_cached_votes_up"
  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"

  create_table "pps", :force => true do |t|
    t.string "name",            :null => false
    t.string "surname",         :null => false
    t.string "middlename"
    t.string "passport",        :null => false
    t.string "passport_issued", :null => false
    t.date   "passport_date",   :null => false
  end

  create_table "programms", :force => true do |t|
    t.string   "name"
    t.time     "time"
    t.text     "description"
    t.integer  "client_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "second_day"
    t.integer  "site_id"
  end

  add_index "programms", ["site_id"], :name => "index_programms_on_site_id"

  create_table "promises", :force => true do |t|
    t.integer  "wishlist_id"
    t.integer  "client_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "promises", ["client_id"], :name => "index_promises_on_user_id"
  add_index "promises", ["wishlist_id"], :name => "index_promises_on_wishlist_id"

  create_table "purse_payments", :force => true do |t|
    t.string   "type"
    t.integer  "source_purse_id"
    t.integer  "purse_id"
    t.integer  "source_payment_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.string   "name"
    t.text     "description"
    t.integer  "amount_cents",      :default => 0, :null => false
    t.string   "state"
    t.text     "params"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "purse_payments", ["purse_id"], :name => "index_purse_payments_on_purse_id"
  add_index "purse_payments", ["source_payment_id"], :name => "index_purse_payments_on_source_payment_id"
  add_index "purse_payments", ["source_purse_id"], :name => "index_purse_payments_on_source_purse_id"
  add_index "purse_payments", ["target_id"], :name => "index_purse_payments_on_target_id"
  add_index "purse_payments", ["target_type"], :name => "index_purse_payments_on_target_type"

  create_table "purses", :force => true do |t|
    t.integer  "amount_cents",   :default => 0, :null => false
    t.integer  "deposit_course", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "question_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "community_id"
  end

  add_index "question_categories", ["community_id"], :name => "index_question_categories_on_community_id"

  create_table "questions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "answer_id"
    t.text     "body"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "recommended",          :default => false
    t.string   "title"
    t.integer  "question_category_id"
  end

  add_index "questions", ["answer_id"], :name => "index_questions_on_answer_id"
  add_index "questions", ["question_category_id"], :name => "index_questions_on_question_category_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "regions", ["country_id"], :name => "index_regions_on_country_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "deleted_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "scripts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "weeks"
  end

  create_table "seating_plans", :force => true do |t|
    t.integer  "site_id"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "seating_plans", ["site_id"], :name => "index_seating_plans_on_site_id"

  create_table "seating_seats", :force => true do |t|
    t.integer  "table_id"
    t.integer  "guest_id"
    t.string   "guest_type"
    t.string   "side"
    t.string   "gender"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "seating_seats", ["guest_id", "guest_type"], :name => "index_seating_seats_on_guest_id_and_guest_type"
  add_index "seating_seats", ["position"], :name => "index_seating_seats_on_position"
  add_index "seating_seats", ["table_id"], :name => "index_seating_seats_on_table_id"

  create_table "seating_tables", :force => true do |t|
    t.integer  "plan_id"
    t.string   "form"
    t.string   "title"
    t.integer  "height"
    t.integer  "width"
    t.integer  "deg"
    t.integer  "left_position"
    t.integer  "top_position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "seating_tables", ["plan_id"], :name => "index_seating_tables_on_plan_id"

  create_table "servises", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "code"
    t.integer  "client_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "logo"
    t.string   "string"
    t.string   "color"
    t.integer  "privacy",             :default => 0
    t.integer  "header_image_id"
    t.integer  "background_image_id"
    t.string   "header_picture"
    t.string   "background_picture"
    t.integer  "cached_votes_up",     :default => 0
  end

  add_index "sites", ["cached_votes_up"], :name => "index_sites_on_cached_votes_up"
  add_index "sites", ["client_id"], :name => "index_sites_on_user_id"
  add_index "sites", ["name"], :name => "index_sites_on_name", :unique => true

  create_table "specifications", :force => true do |t|
    t.integer  "sphere_id"
    t.string   "name"
    t.string   "title"
    t.string   "unit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "value"
    t.integer  "icon_id"
  end

  add_index "specifications", ["sphere_id"], :name => "index_specifications_on_sphere_id"

  create_table "spheres", :force => true do |t|
    t.integer  "firm_id"
    t.integer  "firm_catalog_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "base",            :default => false, :null => false
    t.datetime "deleted_at"
  end

  add_index "spheres", ["firm_catalog_id"], :name => "index_spheres_on_firm_catalog_id"
  add_index "spheres", ["firm_id"], :name => "index_spheres_on_firm_id"

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "is_active",  :default => false
    t.string   "link"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "static_pages", ["link"], :name => "index_static_pages_on_link"

  create_table "system_accounts", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.integer  "purse_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "system_accounts", ["purse_id"], :name => "index_system_accounts_on_purse_id"

  create_table "t_firms", :force => true do |t|
    t.integer  "firm_catalog_id"
    t.integer  "city_id"
    t.string   "name"
    t.string   "extended_name"
    t.string   "phone"
    t.string   "address"
    t.integer  "rating"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "t_firms", ["city_id", "firm_catalog_id", "rating"], :name => "rating_index"
  add_index "t_firms", ["city_id"], :name => "index_t_firms_on_city_id"
  add_index "t_firms", ["firm_catalog_id"], :name => "index_t_firms_on_firm_catalog_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.string  "color"
    t.boolean "accepted",   :default => false
    t.integer "red"
    t.integer "green"
    t.integer "blue"
    t.string  "color_slug"
  end

  create_table "tags_tasks", :id => false, :force => true do |t|
    t.integer "task_id"
    t.integer "tag_id"
  end

  create_table "task_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "task_depends", :force => true do |t|
    t.integer  "task_id"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "task_depends", ["parent_id"], :name => "index_task_depends_on_parent_id"
  add_index "task_depends", ["task_id"], :name => "index_task_depends_on_task_id"

  create_table "task_files", :force => true do |t|
    t.string   "url"
    t.integer  "task_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "task_files", ["task_id"], :name => "index_task_files_on_task_id"

  create_table "task_positions", :force => true do |t|
    t.integer  "task_id"
    t.integer  "plan_id"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "task_category_id"
    t.string   "type_task"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "cap_firm"
    t.string   "service"
    t.string   "image"
  end

  add_index "tasks", ["task_category_id"], :name => "index_tasks_on_task_category_id"

  create_table "timetables", :force => true do |t|
    t.string  "t_type"
    t.date    "date_from"
    t.integer "wedding_id"
    t.integer "index_number"
    t.integer "plan_id"
  end

  add_index "timetables", ["wedding_id"], :name => "index_timetables_on_wedding_id"

  create_table "user_authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.hstore   "data"
    t.integer  "user_id"
    t.boolean  "primary",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "expires_at"
  end

  add_index "user_authorizations", ["user_id"], :name => "index_user_authorizations_on_user_id"

  create_table "user_comment_images", :force => true do |t|
    t.string   "image"
    t.integer  "user_comment_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_comment_images", ["user_comment_id"], :name => "index_user_comment_images_on_user_comment_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => ""
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "invitation_token",       :limit => 64
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "type_user",                            :default => 0
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "friends_count",                        :default => 0,     :null => false
    t.string   "text_status"
    t.text     "description"
    t.string   "login",                  :limit => 32
    t.boolean  "banned",                               :default => false
    t.integer  "profileable_id"
    t.string   "profileable_type"
    t.date     "invitation_created_at"
    t.string   "username",                             :default => "",    :null => false
    t.boolean  "subscription"
    t.datetime "deleted_at"
    t.string   "phone"
    t.integer  "purse_id"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["deleted_at"], :name => "index_users_on_deleted_at"
  add_index "users", ["email", "deleted_at"], :name => "index_users_on_email_and_deleted_at", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["login", "deleted_at"], :name => "index_users_on_login_and_deleted_at", :unique => true
  add_index "users", ["purse_id"], :name => "index_users_on_purse_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "users_weddings_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "client_id"
    t.integer "wedding_id"
  end

  add_index "users_weddings_roles", ["role_id", "client_id", "wedding_id"], :name => "roles_index", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "wedding_calcs", :force => true do |t|
    t.text     "categories"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "site_id"
  end

  add_index "wedding_calcs", ["site_id"], :name => "index_wedding_calcs_on_site_id"

  create_table "wedding_invites", :force => true do |t|
    t.integer  "client_id"
    t.integer  "couple_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wedding_invites", ["client_id"], :name => "index_wedding_invites_on_client_id"

  create_table "weddings", :force => true do |t|
    t.date    "wedding_date"
    t.string  "avatar"
    t.integer "script_id"
    t.date    "start_date"
  end

  add_index "weddings", ["script_id"], :name => "index_weddings_on_script_id"

  create_table "wishlists", :force => true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.boolean  "wish",        :default => true, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "site_id"
  end

  add_index "wishlists", ["client_id"], :name => "index_wishlists_on_user_id"
  add_index "wishlists", ["site_id"], :name => "index_wishlists_on_site_id"

end
