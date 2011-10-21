class Orders < ActiveRecord::Migration
  def self.up
    create_table "orders", :force => true do |t|
      t.integer  "sum"
      t.text     "message"
      t.text     "note"
      t.integer  "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      # foreign keys
      t.integer  "customer_id"
    end
    add_index :orders, :customer_id
  end

  def self.down
    drop_table 'orders'
  end
end
