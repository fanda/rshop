class AddCustomerAuth < ActiveRecord::Migration
  def self.up
     add_column :customers, :crypted_password,    :string         
     add_column :customers, :password_salt,       :string  
     add_column :customers, :persistence_token,   :string, :null => false  
  end

  def self.down
    remove_column :customers, :crypted_password
    remove_column :customers, :password_salt
    remove_column :customers, :persistence_token
  end
end
