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

ActiveRecord::Schema.define(version: 20150726050435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.string "name", null: false
  end

  add_index "channels", ["name"], name: "index_channels_on_name", using: :btree

  create_table "channels_pull_requests", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "pull_request_id"
  end

  add_index "channels_pull_requests", ["channel_id", "pull_request_id"], name: "index_channels_pull_requests_on_channel_id_and_pull_request_id", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string  "name",               null: false
    t.string  "github_url",         null: false
    t.integer "default_channel_id", null: false
  end

  create_table "pull_requests", force: :cascade do |t|
    t.datetime "created_at",                                                                          null: false
    t.datetime "updated_at",                                                                          null: false
    t.string   "github_url",                                                                          null: false
    t.string   "repo_name",                                                                           null: false
    t.string   "status",          default: "needs review",                                            null: false
    t.string   "title",                                                                               null: false
    t.string   "repo_github_url",                                                                     null: false
    t.string   "user_name",                                                                           null: false
    t.string   "user_github_url",                                                                     null: false
    t.string   "avatar_url",      default: "https://avatars1.githubusercontent.com/u/6183?v=3&s=200", null: false
    t.integer  "additions",       default: 0,                                                         null: false
    t.integer  "deletions",       default: 0,                                                         null: false
    t.datetime "reposted_at"
  end

  add_index "pull_requests", ["status"], name: "index_pull_requests_on_status", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",       null: false
    t.integer "channel_id", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  add_foreign_key "projects", "channels", column: "default_channel_id", on_delete: :cascade
end
