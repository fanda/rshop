class Actions < ActiveRecord::Migration

  def self.up
    create_table "actions", :force => true do |t|
      t.integer  "counter", :default => 0
      t.string   "control"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index :actions, :created_at
    add_index :actions, :control
  end

  def self.down
    remove_index :actions, :control
    remove_index :actions, :created_at
    drop_table 'actions'       
  end
end
