class Categories < ActiveRecord::Migration
  def self.up
    create_table "categories", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.string   "slug"
      t.integer  "position"
      # awesome nested set
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
    end
    add_index :categories, :parent_id
    add_index :categories, :slug, :unique => true
  end

  def self.down
    drop_table 'categories'
  end
end
