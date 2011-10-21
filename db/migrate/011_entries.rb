class Entries < ActiveRecord::Migration
  def self.up
    create_table "entries", :force => true do |t|
      t.integer  "quantity"
      t.integer  "supply_id"
      t.integer  "product_id"
    end
    add_index :entries, :supply_id
    add_index :entries, :product_id
  end

  def self.down
    drop_table 'entries'
  end
end
