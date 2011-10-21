class Products < ActiveRecord::Migration
  def self.up
    create_table "products", :force => true do |t|
      t.string   "title", :null => false
      t.text     "description"
      t.integer  "price"
      t.integer  "amount"
      t.integer  "counter", :default => 0
      t.integer  "position"
      t.integer  "active", :limit => 2, :default => 1
      t.datetime "created_at"
      t.datetime "updated_at"
      # picture (paperclip)
      t.string   'picture_file_name'
      t.string   'picture_content_type'
      t.integer  'picture_file_size'
      t.datetime 'picture_updated_at'
      # foreign keys
      t.integer  "item_id"
      t.integer  "category_id"
      t.integer  "supplier_id"
    end
    add_index :products, :item_id
    add_index :products, :category_id
    add_index :products, :supplier_id
  end

  def self.down
    drop_table 'products'
  end
end
