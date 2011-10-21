class Items < ActiveRecord::Migration
  def self.up
    create_table "items", :force => true do |t|
      t.integer  "price"
      t.integer  "amount"
      # foreign keys
      t.integer  "order_id"
      t.integer  "product_id"
    end
    add_index :items, :order_id
    add_index :items, :product_id
  end

  def self.down
    drop_table 'items'
  end
end
