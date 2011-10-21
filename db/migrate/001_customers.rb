class Customers < ActiveRecord::Migration
  def self.up
    create_table "customers", :force => true do |t|
      # from ER design
      t.string   "email"
      t.string   "phone"
      t.string   "name"
      t.string   "surname"
      t.string   "street"
      t.string   "place"
      t.string   "post_code"
      # useful stuff
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index :customers, :email
  end

  def self.down
    drop_table 'customers'
  end
end
