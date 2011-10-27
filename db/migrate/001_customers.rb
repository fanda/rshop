class Customers < ActiveRecord::Migration
  def self.up
    create_table "customers", :force => true do |t|
      # from ER design
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      #t.string   "email"
      t.string   "phone"
      t.string   "name"
      t.string   "surname"
      t.string   "street"
      t.string   "place"
      t.string   "post_code"
      # useful stuff
      t.timestamps
    end
    add_index :customers, :email,                :unique => true
    add_index :customers, :reset_password_token, :unique => true
  end

  def self.down
    drop_table 'customers'
  end
end
