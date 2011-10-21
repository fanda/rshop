class AddEmployeeAuth < ActiveRecord::Migration
  def self.up
     add_column :employees, :crypted_password,    :string, :null => false         
     add_column :employees, :password_salt,       :string, :null => false  
     add_column :employees, :persistence_token,   :string, :null => false  
     add_column :employees, :perishable_token,    :string, :null => false
  end

  def self.down
    remove_column :employees, :crypted_password
    remove_column :employees, :password_salt
    remove_column :employees, :persistence_token
    remove_column :employees, :perishable_token
  end
end
