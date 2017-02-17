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

ActiveRecord::Schema.define(version: 20170119191358) do

  create_table "comments", force: :cascade do |t|
    t.string "pid"
    t.string "uname"
    t.text   "comment"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "price"
    t.string   "city"
    t.string   "address"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.string  "size"
    t.string  "category"
    t.integer "popularity"
    t.string  "image"
    t.string  "price"
  end

  create_table "userproducts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.integer "order_id"
    t.string  "size"
    t.integer "quantity"
    t.string  "status"
    t.index ["order_id"], name: "index_userproducts_on_order_id"
    t.index ["product_id"], name: "index_userproducts_on_product_id"
    t.index ["user_id"], name: "index_userproducts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password"
    t.string "password_salt"
    t.string "role"
  end

end
