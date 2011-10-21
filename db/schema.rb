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

ActiveRecord::Schema.define(:version => 16) do

  create_table "actions", :force => true do |t|
    t.integer  "counter",    :default => 0
    t.string   "control"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["control"], :name => "index_actions_on_control"
  add_index "actions", ["created_at"], :name => "index_actions_on_created_at"

  create_table "categories", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.integer "position"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.string  "cached_slug"
  end

  add_index "categories", ["cached_slug"], :name => "index_categories_on_cached_slug", :unique => true
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "customers", :force => true do |t|
    t.string   "email"
    t.string   "phone"
    t.string   "name"
    t.string   "surname"
    t.string   "street"
    t.string   "place"
    t.string   "post_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token", :null => false
  end

  add_index "customers", ["email"], :name => "index_customers_on_email"

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password",  :null => false
    t.string   "password_salt",     :null => false
    t.string   "persistence_token", :null => false
    t.string   "perishable_token",  :null => false
  end

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
    t.integer "price"
    t.integer "amount"
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
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "item_id"
    t.integer  "category_id"
    t.integer  "supplier_id"
    t.string   "cached_slug"
  end

  add_index "products", ["cached_slug"], :name => "index_products_on_cached_slug"
  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["item_id"], :name => "index_products_on_item_id"
  add_index "products", ["supplier_id"], :name => "index_products_on_supplier_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

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
    t.integer  "employee_id"
  end

  add_index "supplies", ["employee_id"], :name => "index_supplies_on_employee_id"
  add_index "supplies", ["supplier_id"], :name => "index_supplies_on_supplier_id"

end
