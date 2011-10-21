class Suppliers < ActiveRecord::Migration
  def self.up
    create_table "suppliers", :force => true do |t|
      t.string   "name"
      t.string   "email"
      t.string   "phone"
      t.string   "url"
      t.string   "street"
      t.string   "place"
      t.string   "post_code"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table 'suppliers'
  end
end
