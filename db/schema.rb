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

ActiveRecord::Schema.define(:version => 13) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.string   "namespace"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "categories", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.string  "slug"
    t.integer "position"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "customers", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "phone"
    t.string   "name"
    t.string   "surname"
    t.string   "street"
    t.string   "place"
    t.string   "post_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["email"], :name => "index_customers_on_email", :unique => true
  add_index "customers", ["reset_password_token"], :name => "index_customers_on_reset_password_token", :unique => true

  create_table "entries", :force => true do |t|
    t.integer "quantity"
    t.integer "supply_id"
    t.integer "product_id"
  end

  add_index "entries", ["product_id"], :name => "index_entries_on_product_id"
  add_index "entries", ["supply_id"], :name => "index_entries_on_supply_id"

  create_table "invoice_addresses", :force => true do |t|
    t.integer "order_id"
    t.string  "name"
    t.string  "street"
    t.string  "place"
    t.string  "post_code"
    t.string  "id_number"
    t.string  "vat_number"
  end

  create_table "invoices", :force => true do |t|
    t.string   "number"
    t.integer  "order_id"
    t.datetime "created_at"
  end

  add_index "invoices", ["order_id"], :name => "index_invoices_on_order_id"

  create_table "items", :force => true do |t|
    t.integer "cost"
    t.integer "count"
    t.integer "order_id"
    t.integer "product_id"
  end

  add_index "items", ["order_id"], :name => "index_items_on_order_id"
  add_index "items", ["product_id"], :name => "index_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "sum"
    t.text     "message"
    t.text     "note"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["url"], :name => "index_pages_on_url"

  create_table "products", :force => true do |t|
    t.string   "title",                                            :null => false
    t.text     "description"
    t.integer  "price"
    t.integer  "amount"
    t.integer  "counter",                           :default => 0
    t.integer  "position"
    t.integer  "active",               :limit => 2, :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "category_id"
    t.integer  "supplier_id"
  end

  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["slug"], :name => "index_products_on_slug", :unique => true
  add_index "products", ["supplier_id"], :name => "index_products_on_supplier_id"

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "url"
    t.string   "street"
    t.string   "place"
    t.string   "post_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplies", :force => true do |t|
    t.integer  "sum"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivered_at"
    t.integer  "supplier_id"
    t.integer  "admin_user_id"
  end

  add_index "supplies", ["admin_user_id"], :name => "index_supplies_on_admin_user_id"
  add_index "supplies", ["supplier_id"], :name => "index_supplies_on_supplier_id"

end
