class Customers < ActiveRecord::Migration
  def self.up
    create_table "customers", :force => true do |t|
      # from ER design

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

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
