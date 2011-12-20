class AdminComments < ActiveRecord::Migration
  def self.up
    remove_column :orders, :note
  end

  def self.down
    add_column :orders, :note, :string
  end
end
