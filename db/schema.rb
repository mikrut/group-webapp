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

ActiveRecord::Schema.define(version: 20151008185009) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "contents",      limit: 65535
    t.integer  "author_id",     limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "discipline_id", limit: 4
  end

  add_index "articles", ["author_id"], name: "fk_rails_6fc3b668ee", using: :btree
  add_index "articles", ["discipline_id"], name: "index_articles_on_discipline_id", using: :btree

  create_table "disciplines", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "group_id",    limit: 4
  end

  add_index "disciplines", ["group_id"], name: "index_disciplines_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "semester",      limit: 4
    t.integer  "cathedra",      limit: 4
    t.string   "faculty",       limit: 255
    t.string   "faculty_name",  limit: 255
    t.string   "cathedra_name", limit: 255
    t.integer  "index",         limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "discipline_id",  limit: 4
    t.integer "group_id",       limit: 4
    t.integer "weekday",        limit: 4
    t.integer "occurence_type", limit: 4
    t.integer "time_index",     limit: 4
    t.integer "lesson_type",    limit: 4
  end

  add_index "lessons", ["discipline_id"], name: "index_lessons_on_discipline_id", using: :btree
  add_index "lessons", ["group_id"], name: "index_lessons_on_group_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.text     "description",           limit: 65535
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.integer  "user_id",               limit: 4
    t.integer  "discipline_id",         limit: 4
  end

  add_index "materials", ["discipline_id"], name: "index_materials_on_discipline_id", using: :btree
  add_index "materials", ["user_id"], name: "index_materials_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.date     "date_of_birth"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "role",            limit: 4
    t.string   "password_digest", limit: 255
    t.integer  "group_id",        limit: 4
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

  add_foreign_key "articles", "disciplines"
  add_foreign_key "articles", "users", column: "author_id"
  add_foreign_key "disciplines", "groups"
  add_foreign_key "lessons", "disciplines"
  add_foreign_key "lessons", "groups"
  add_foreign_key "users", "groups"
end
