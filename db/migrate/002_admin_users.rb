class AdminUsers < ActiveRecord::Migration
  def self.up
    create_table(:admin_users) do |t|
      t.string   "name"
      t.string   "phone"

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

      t.timestamps
    end

    add_index :admin_users, :email,                :unique => true
    add_index :admin_users, :reset_password_token, :unique => true
    # add_index :admin_users, :confirmation_token,   :unique => true
    # add_index :admin_users, :unlock_token,         :unique => true
    # add_index :admin_users, :authentication_token, :unique => true


    # Create a default user
    AdminUser.create!(:email => 'fandisek@gmail.com', :password => 'Hesl1ck0011', :password_confirmation => 'Hesl1ck0011')

  end

  def self.down
    drop_table :admin_users
  end
end
