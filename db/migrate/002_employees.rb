class Employees < ActiveRecord::Migration

  def self.up
    create_table "employees", :force => true do |t|
      t.string   "name"
      t.string   "email"
      t.string   "phone"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

  end

  def self.down
    drop_table 'employees'
  end
end
