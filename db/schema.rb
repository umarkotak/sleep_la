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

ActiveRecord::Schema[8.0].define(version: 2025_09_18_075253) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "user_sleep_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "sleep_date"
    t.datetime "sleep_at"
    t.datetime "wake_at"
    t.bigint "duration_second"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sleep_date"], name: "index_user_sleep_logs_on_sleep_date"
    t.index ["user_id"], name: "index_user_sleep_logs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.uuid "guid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_users_on_guid", unique: true
  end

  add_foreign_key "user_sleep_logs", "users"
end
