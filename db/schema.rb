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

ActiveRecord::Schema.define(version: 20151116064526) do

  create_table "absenses", force: :cascade do |t|
    t.integer "user_id",           limit: 4
    t.integer "lesson_id",         limit: 4
    t.integer "week",              limit: 4
    t.text    "reason_commentary", limit: 16777215
  end

  add_index "absenses", ["lesson_id"], name: "index_absenses_on_lesson_id", using: :btree
  add_index "absenses", ["user_id"], name: "index_absenses_on_user_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "contents",      limit: 16777215
    t.integer  "author_id",     limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "discipline_id", limit: 4
  end

  add_index "articles", ["author_id"], name: "fk_rails_e989f92da8", using: :btree
  add_index "articles", ["discipline_id"], name: "index_articles_on_discipline_id", using: :btree

  create_table "disciplines", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 16777215
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
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
    t.string   "supervisor",    limit: 255
    t.string   "decanus",       limit: 255
    t.string   "zamdecanus",    limit: 255
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "secret_key", limit: 255
    t.string   "username",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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
    t.text     "description",           limit: 16777215
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.integer  "user_id",               limit: 4
    t.integer  "discipline_id",         limit: 4
  end

  add_index "materials", ["discipline_id"], name: "index_materials_on_discipline_id", using: :btree
  add_index "materials", ["user_id"], name: "index_materials_on_user_id", using: :btree

  create_table "progresses", force: :cascade do |t|
    t.float    "percentage",    limit: 24, default: 0.0, null: false
    t.integer  "user_id",       limit: 4
    t.integer  "discipline_id", limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "progresses", ["discipline_id"], name: "index_progresses_on_discipline_id", using: :btree
  add_index "progresses", ["user_id"], name: "index_progresses_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.date     "date_of_birth"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "role",            limit: 4
    t.string   "password_digest", limit: 255
    t.integer  "group_id",        limit: 4
    t.string   "first_name",      limit: 255, default: "Firstname",  null: false
    t.string   "last_name",       limit: 255, default: "Lastname",   null: false
    t.string   "middle_name",     limit: 255, default: "Middlename", null: false
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

  add_foreign_key "disciplines", "groups"
  add_foreign_key "lessons", "disciplines"
  add_foreign_key "lessons", "groups"
  add_foreign_key "users", "groups"
end
