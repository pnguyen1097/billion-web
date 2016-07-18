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

ActiveRecord::Schema.define(version: 20160718052859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "author",     default: "", null: false
    t.text     "content",    default: "", null: false
    t.integer  "project_id",              null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "comments", ["project_id"], name: "index_comments_on_project_id", using: :btree

  create_table "competitions", force: :cascade do |t|
    t.string   "code_name",       default: "",   null: false
    t.date     "start_date",                     null: false
    t.date     "end_date",                       null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "dollar_to_point", default: 1,    null: false
    t.boolean  "open_donation",   default: true, null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "project_1_id"
    t.integer  "project_2_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["project_1_id"], name: "index_matches_on_project_1_id", using: :btree
  add_index "matches", ["project_2_id"], name: "index_matches_on_project_2_id", using: :btree
  add_index "matches", ["round_id"], name: "index_matches_on_round_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id",    null: false
  end

  add_index "memberships", ["project_id"], name: "index_memberships_on_project_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",              default: "",    null: false
    t.text     "blurb"
    t.text     "description"
    t.integer  "competition_id",                    null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "video_url"
    t.string   "card_image_url"
    t.string   "project_image_url"
    t.string   "short_name"
    t.string   "slug"
    t.datetime "eliminated_at"
    t.boolean  "wine",              default: false, null: false
  end

  add_index "projects", ["competition_id"], name: "index_projects_on_competition_id", using: :btree
  add_index "projects", ["name"], name: "index_projects_on_name", using: :btree
  add_index "projects", ["short_name"], name: "index_projects_on_short_name", using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "competition_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_number"
  end

  add_index "rounds", ["competition_id"], name: "index_rounds_on_competition_id", using: :btree

  create_table "temp_users", force: :cascade do |t|
    t.string   "email",                      null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "in_person",  default: false
  end

  add_index "temp_users", ["email"], name: "index_temp_users_on_email", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount",         precision: 7, scale: 2
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "recipient_id",                           null: false
    t.string   "recipient_type",                         null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "points",                                 null: false
    t.integer  "competition_id",                         null: false
  end

  add_index "transactions", ["amount"], name: "index_transactions_on_amount", using: :btree
  add_index "transactions", ["competition_id"], name: "index_transactions_on_competition_id", using: :btree
  add_index "transactions", ["recipient_type", "recipient_id"], name: "index_transactions_on_recipient_type_and_recipient_id", using: :btree
  add_index "transactions", ["sender_type", "sender_id"], name: "index_transactions_on_sender_type_and_sender_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",            default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",          default: 0
    t.integer  "role_id"
    t.string   "bio"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profile_image_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  add_foreign_key "matches", "projects", column: "project_1_id"
  add_foreign_key "matches", "projects", column: "project_2_id"
  add_foreign_key "matches", "rounds"
  add_foreign_key "rounds", "competitions"
end
