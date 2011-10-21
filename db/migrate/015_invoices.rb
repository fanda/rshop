class Invoices < ActiveRecord::Migration
  def self.up
    create_table "invoices", :force => true do |t|
      t.string    "number"
      t.integer   "order_id"
      t.datetime  "created_at"
      #t.integer   "forma"
      #t.text      "item_ids"
    end
    add_index :invoices, :order_id
  end

  def self.down
    drop_table 'invoices'
  end
end
