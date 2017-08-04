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

ActiveRecord::Schema.define(version: 20170801085555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "avg",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bulks", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "group_id"
  end

  create_table "commontator_comments", force: :cascade do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
  add_index "commontator_comments", ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at", using: :btree

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree

  create_table "commontator_threads", force: :cascade do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "tags"
    t.string   "image"
    t.string   "city"
    t.string   "address"
    t.string   "country"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "subdomain"
    t.string   "contact"
    t.string   "logo"
    t.integer  "plan"
    t.json     "properties"
    t.string   "email"
  end

  add_index "companies", ["slug"], name: "index_companies_on_slug", unique: true, using: :btree
  add_index "companies", ["subdomain"], name: "index_companies_on_subdomain", unique: true, using: :btree

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

  create_table "file_uploads", force: :cascade do |t|
    t.string   "file_link"
    t.integer  "file_type"
    t.integer  "user_id"
    t.integer  "interview_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "auto_response"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "company_id"
    t.string   "slug"
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interviews", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "salary_range"
    t.datetime "deadline"
    t.string   "tags"
    t.json     "questions"
    t.text     "instruction"
    t.text     "mail_list"
    t.string   "interview_token"
    t.text     "shortlist_message"
    t.text     "invite_message"
    t.text     "reject_message"
    t.integer  "company_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "slug"
    t.string   "completed_message"
    t.string   "status"
    t.integer  "approve",           default: 0
    t.string   "city"
    t.string   "state"
    t.string   "country"
  end

  add_index "interviews", ["slug"], name: "index_interviews_on_slug", unique: true, using: :btree

  create_table "joint_user_companies", force: :cascade do |t|
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "message"
    t.integer  "read"
    t.integer  "type_notification"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "oauth_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
    t.string   "profile_url"
    t.string   "access_token"
    t.text     "raw_data"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "oauth_accounts", ["user_id"], name: "index_oauth_accounts_on_user_id", using: :btree

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "overall_avg",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type", using: :btree
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id", using: :btree

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type", using: :btree

  create_table "request_demos", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "organization"
    t.string   "role"
    t.string   "purpose"
    t.string   "additional_message"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "telephone"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "interview_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "current_no"
    t.json     "answers"
    t.integer  "first_video"
    t.integer  "device"
  end

  create_table "text_uploads", force: :cascade do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "submission_id"
    t.integer  "interview_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "telephone"
    t.string   "a_qualification"
    t.integer  "a_experience"
    t.string   "a_dp"
    t.string   "a_gender"
    t.datetime "a_dob"
    t.string   "a_cv"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.integer  "status"
    t.integer  "last_company"
    t.string   "about_me"
    t.string   "skill"
    t.string   "school"
    t.string   "descipline"
    t.string   "occupation"
    t.integer  "profile_access"
    t.integer  "marital_status"
    t.string   "state"
    t.string   "nationality"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "oauth_accounts", "users"
end
