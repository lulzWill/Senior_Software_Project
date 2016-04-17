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

ActiveRecord::Schema.define(version: 20160415154221) do

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "profile_pic"
    t.string   "activity_type"
    t.text     "data"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "albums", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.integer  "cover"
    t.string   "privacy"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id"
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id"

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legs", force: :cascade do |t|
    t.string   "name"
    t.integer  "trip_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.string   "title"
    t.string   "data"
    t.string   "description"
    t.integer  "album_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.string   "visit_id"
    t.integer  "rating"
    t.string   "comment"
    t.integer  "flags"
    t.boolean  "allowed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.integer  "main_user_id"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "user_id"
    t.string   "password_digest"
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "profile_pic"
    t.string   "session_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "visits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
