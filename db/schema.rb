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

ActiveRecord::Schema.define(version: 20180212113646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dashboard_widgets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "type", null: false
    t.jsonb "settings", default: {}, null: false
    t.index ["user_id"], name: "index_dashboard_widgets_on_user_id"
  end

  create_table "email_notifications", force: :cascade do |t|
    t.integer "template", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.bigint "notifiable_role_id"
    t.bigint "notifiable_user_id"
    t.string "subject", null: false
    t.text "text", null: false
    t.index ["notifiable_role_id"], name: "index_email_notifications_on_notifiable_role_id"
    t.index ["notifiable_user_id"], name: "index_email_notifications_on_notifiable_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.integer "permissions", default: [], null: false, array: true
    t.boolean "admin", default: false, null: false
  end

  create_table "roles_users", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "time_zone", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dashboard_widgets", "users", name: "dashboard_widgets_user_id_fkey"
  add_foreign_key "email_notifications", "roles", column: "notifiable_role_id", name: "email_notifications_notifiable_role_id_fkey"
  add_foreign_key "email_notifications", "users", column: "notifiable_user_id", name: "email_notifications_notifiable_user_id_fkey"
  add_foreign_key "roles_users", "roles", name: "roles_users_role_id_fkey"
  add_foreign_key "roles_users", "users", name: "roles_users_user_id_fkey"
end
