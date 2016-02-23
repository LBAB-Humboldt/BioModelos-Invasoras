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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160122155421) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "activities", force: :cascade do |t|
    t.string "name",        limit: 255, null: false
    t.text   "description"
  end

  create_table "activity_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "species_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_users", ["user_id", "species_id"], name: "index_activity_users_on_user_id_and_species_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "altitude_ranges", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "species_id"
    t.integer  "alt_min",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alt_max",    default: 0
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_species", force: :cascade do |t|
    t.integer  "species_id",    null: false
    t.integer  "categories_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories_species", ["species_id", "categories_id"], name: "index_categories_species_on_species_id_and_categories_id"

  create_table "classes", force: :cascade do |t|
    t.string   "class_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",               default: 0
    t.string   "commentable_type", limit: 255
    t.string   "title",            limit: 255
    t.text     "body"
    t.string   "subject",          limit: 255
    t.integer  "user_id",                      default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "eco_variables", force: :cascade do |t|
    t.string   "variable",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eco_variables_species", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "species_id"
    t.integer  "eco_variable_id"
    t.float    "min",             default: 0.0
    t.float    "max",             default: 0.0
    t.float    "mean",            default: 0.0
    t.float    "certainty",       default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_user_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "is_admin"
    t.integer  "group_user_state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.text     "description"
    t.string   "img_url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "link"
    t.string   "logo"
    t.integer  "group_state_id"
  end

  create_table "groups_species", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "species_id"
  end

  add_index "groups_species", ["group_id", "species_id"], name: "index_groups_species_on_group_id_and_species_id", unique: true

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true

  create_table "models", force: :cascade do |t|
    t.integer  "species_id"
    t.string   "img_url",     limit: 255
    t.date     "model_date"
    t.string   "author",      limit: 255
    t.text     "description"
    t.integer  "rating",                  default: 0
    t.boolean  "validated",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumb_url",   limit: 255
    t.boolean  "current",                 default: true
    t.integer  "level",                   default: 1
  end

  add_index "models", ["species_id", "current"], name: "index_models_on_species_id_and_current"

  create_table "periodicities", force: :cascade do |t|
    t.string   "name"
    t.integer  "days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "point_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "species_id"
    t.decimal  "lat"
    t.decimal  "lon"
    t.boolean  "wrong_id",                default: false
    t.boolean  "geo_problem",             default: false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "register_id", limit: 255
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "model_id"
    t.integer  "score",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
  end

  add_index "regions", ["name"], name: "index_regions_on_name", unique: true

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "model_id"
    t.text     "geoJSON",    limit: 2097152
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["model_id"], name: "index_reviews_on_model_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "species", force: :cascade do |t|
    t.integer  "class_id"
    t.string   "sci_name",              limit: 255
    t.string   "order",                 limit: 255
    t.string   "family",                limit: 255
    t.string   "sib_url",               limit: 255
    t.integer  "ocurrence_records"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ocurrence_records_url", limit: 255
    t.string   "iucn_id",               limit: 255
    t.boolean  "current",                           default: true
  end

  add_index "species", ["class_id"], name: "index_species_on_class_id"
  add_index "species", ["sci_name"], name: "index_species_on_sci_name", unique: true

  create_table "species_group_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species_groups", force: :cascade do |t|
    t.integer  "species_id"
    t.integer  "group_id"
    t.integer  "species_group_state_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_species_regions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "region_id"
    t.integer  "species_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "role",                   limit: 255
    t.string   "location",               limit: 255
    t.string   "organization",           limit: 255
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "avatarUrl",              limit: 255
    t.string   "interestGroups",         limit: 255
    t.integer  "mail_periodicity"
    t.integer  "group_id"
    t.string   "requested_group_name"
    t.date     "last_email_send"
    t.integer  "periodicity_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
