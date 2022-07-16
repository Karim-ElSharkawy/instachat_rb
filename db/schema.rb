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

ActiveRecord::Schema[7.0].define(version: 2022_07_16_144337) do
  create_table "chats", charset: "utf8", force: :cascade do |t|
    t.integer "application_chat_number", default: 1, null: false, unsigned: true
    t.integer "messages_count", default: 0, unsigned: true
    t.bigint "user_application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_chat_number"], name: "index_chats_on_application_chat_number"
    t.index ["user_application_id"], name: "index_chats_on_user_application_id"
  end

  create_table "messages", charset: "utf8", force: :cascade do |t|
    t.string "text"
    t.integer "chat_message_number", default: 1, null: false, unsigned: true
    t.bigint "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "user_applications", charset: "utf8", force: :cascade do |t|
    t.string "token", limit: 36
    t.string "name", null: false
    t.integer "chats_count", default: 0, unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_user_applications_on_token"
  end

  add_foreign_key "chats", "user_applications"
  add_foreign_key "messages", "chats"
end
