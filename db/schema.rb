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

ActiveRecord::Schema.define(version: 20140126040710) do

  create_table "document_manegers", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "file_path"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_manegers", ["group_id"], name: "index_document_manegers_on_group_id"
  add_index "document_manegers", ["user_id"], name: "index_document_manegers_on_user_id"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group_id"
    t.string   "file_path"
    t.string   "file_name"
    t.boolean  "doc_flg"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"

  create_table "relationship_group_users", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationship_group_users", ["group_id", "user_id"], name: "index_relationship_group_users_on_group_id_and_user_id", unique: true
  add_index "relationship_group_users", ["group_id"], name: "index_relationship_group_users_on_group_id"
  add_index "relationship_group_users", ["user_id"], name: "index_relationship_group_users_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.boolean  "confirm",         default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
