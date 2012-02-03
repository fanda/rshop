class AddTimestampsToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :updated_at, :datetime
    add_column :categories, :created_at, :datetime
  end

  def self.down
    remove_column :categories, :created_at
    remove_column :categories, :updated_at
  end
end
