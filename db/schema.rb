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

ActiveRecord::Schema.define(version: 20151201041555) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name"

  create_table "fixed_assets", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "mfg_name"
    t.string   "model_num"
    t.string   "serial_num"
    t.text     "description"
    t.datetime "purchase_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "fixed_assets", ["category_id"], name: "index_fixed_assets_on_category_id"

  create_table "fixed_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "fixed_asset_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "fixed_assignments", ["fixed_asset_id"], name: "index_fixed_assignments_on_fixed_asset_id"
  add_index "fixed_assignments", ["user_id"], name: "index_fixed_assignments_on_user_id"

  create_table "unfixed_assets", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "mfg_name"
    t.string   "model_num"
    t.string   "serial_num"
    t.text     "description"
    t.datetime "purchase_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "unfixed_assets", ["category_id"], name: "index_unfixed_assets_on_category_id"

  create_table "unfixed_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "unfixed_asset_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "unfixed_assignments", ["unfixed_asset_id"], name: "index_unfixed_assignments_on_unfixed_asset_id"
  add_index "unfixed_assignments", ["user_id"], name: "index_unfixed_assignments_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["username"], name: "index_users_on_username"

end
