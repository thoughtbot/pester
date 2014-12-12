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

ActiveRecord::Schema.define(version: 20141212221130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
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

  create_table "pull_requests", force: true do |t|
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "github_issue_id",                          null: false
    t.string   "github_url",                               null: false
    t.string   "repo_name",                                null: false
    t.string   "status",          default: "needs review", null: false
    t.string   "title",                                    null: false
    t.string   "repo_github_url",                          null: false
    t.string   "user_name",                                null: false
    t.string   "user_github_url",                          null: false
  end

  add_index "pull_requests", ["status"], name: "index_pull_requests_on_status", using: :btree

  create_table "pull_requests_tags", force: true do |t|
    t.integer "pull_request_id"
    t.integer "tag_id"
  end

  add_index "pull_requests_tags", ["pull_request_id", "tag_id"], name: "index_pull_requests_tags_on_pull_request_id_and_tag_id", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name",        null: false
    t.string "webhook_url"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  add_foreign_key "pull_requests_tags", "pull_requests"
  add_foreign_key "pull_requests_tags", "tags"
end
