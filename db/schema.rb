# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_28_045559) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "guest_phone_numbers", force: :cascade do |t|
    t.bigint "guest_id", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id", "phone_number"], name: "index_guest_phone_numbers_on_guest_id_and_phone_number", unique: true
    t.index ["guest_id"], name: "index_guest_phone_numbers_on_guest_id"
  end

  create_table "guests", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.string "currency", null: false
    t.string "status", default: "pending", null: false
    t.string "localized_description"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "number_of_guests", default: 0, null: false
    t.integer "number_of_nights", default: 0, null: false
    t.integer "number_of_adults", default: 0, null: false
    t.integer "number_of_children", default: 0, null: false
    t.integer "number_of_infants", default: 0, null: false
    t.float "total_price", default: 0.0, null: false
    t.float "security_price", default: 0.0, null: false
    t.float "payout_price", default: 0.0, null: false
    t.bigint "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
  end

  add_foreign_key "guest_phone_numbers", "guests"
  add_foreign_key "reservations", "guests"
end
