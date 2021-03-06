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

ActiveRecord::Schema.define(:version => 20140414161255) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "access_code"
    t.string   "permissions_store"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "organization_id"
    t.boolean  "enabled",           :default => true
  end

  create_table "masasx_clerks", :force => true do |t|
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

  add_index "masasx_clerks", ["email"], :name => "index_masasx_clerks_on_email", :unique => true
  add_index "masasx_clerks", ["reset_password_token"], :name => "index_masasx_clerks_on_reset_password_token", :unique => true

  create_table "organization_admins", :force => true do |t|
    t.string   "email"
    t.integer  "contact_info_id"
    t.integer  "organization_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.string   "last_name"
    t.string   "language"
    t.string   "office_phone"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "postal_code"
    t.string   "first_name"
    t.string   "uuid"
    t.string   "country",                :default => ""
    t.string   "state",                  :default => ""
  end

  add_index "organization_admins", ["email"], :name => "index_organization_admins_on_email", :unique => true
  add_index "organization_admins", ["reset_password_token"], :name => "index_organization_admins_on_reset_password_token", :unique => true

  create_table "organizations", :force => true do |t|
    t.string   "status"
    t.string   "name"
    t.string   "department"
    t.string   "address_line_1"
    t.string   "telephone"
    t.string   "website"
    t.text     "references"
    t.text     "questions"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "address_line_2"
    t.string   "city"
    t.string   "postal_code"
    t.text     "admin_notes"
    t.string   "uuid"
    t.string   "country",        :default => ""
    t.string   "state",          :default => ""
    t.string   "email"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
