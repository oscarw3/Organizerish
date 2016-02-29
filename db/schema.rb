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

ActiveRecord::Schema.define(version: 20160229204857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "resourcemanagement"
    t.integer  "reservationmanagement"
    t.integer  "usermanagement"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.boolean  "hidden"
  end

  create_table "groups_permissions", id: false, force: :cascade do |t|
    t.integer "group_id",      null: false
    t.integer "permission_id", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "viewaccess"
    t.integer  "reserveaccess"
    t.integer  "resource_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "permissions", ["resource_id"], name: "index_permissions_on_resource_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "occupied"
    t.integer  "resource_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "recurring"
  end

  add_index "reservations", ["resource_id"], name: "index_reservations_on_resource_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "resources", ["user_id"], name: "index_resources_on_user_id", using: :btree

  create_table "resources_tags", id: false, force: :cascade do |t|
    t.integer "resource_id", null: false
    t.integer "tag_id",      null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "role",                   default: 1
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "permissions", "resources"
  add_foreign_key "reservations", "resources"
  add_foreign_key "resources", "users"
end
