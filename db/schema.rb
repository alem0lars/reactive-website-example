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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120527145951) do

  create_table "actions", :force => true do |t|
    t.string   "name",        :limit => 128
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "description"
    t.string   "status",      :limit => 9
    t.integer  "step_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "branches", :force => true do |t|
    t.string   "name",       :limit => 128
    t.integer  "project_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "builds", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "commit_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "status"
  end

  create_table "commits", :force => true do |t|
    t.string   "digest",     :limit => 512
    t.string   "url",        :limit => 2000
    t.datetime "timestamp"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "dependencies", :force => true do |t|
    t.string   "name",       :limit => 128
    t.string   "url",        :limit => 2000
    t.string   "stage",      :limit => 64
    t.integer  "project_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "outputs", :force => true do |t|
    t.string   "name",         :limit => 128
    t.text     "content"
    t.string   "content_kind", :limit => 64
    t.integer  "action_id"
    t.string   "type"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name",        :limit => 24
    t.text     "description"
    t.string   "website",     :limit => 2000
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "steps", :force => true do |t|
    t.string   "name",               :limit => 256
    t.integer  "build_id"
    t.integer  "version_manager_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name",             :limit => 128
    t.integer  "tagged_output_id"
    t.integer  "output_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "role"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "version_managers", :force => true do |t|
    t.string   "version",    :limit => 128
    t.string   "kind",       :limit => 64
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
