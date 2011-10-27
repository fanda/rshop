class Supplies < ActiveRecord::Migration
  def self.up
    create_table "supplies", :force => true do |t|
      t.integer  "sum"
      t.integer  "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.date     "delivered_at"
      t.integer  "supplier_id"
      t.integer  "admin_user_id"
    end
    add_index :supplies, :supplier_id
    add_index :supplies, :admin_user_id
  end

  def self.down
    drop_table 'supplies'
  end
end
