class InvoiceAddress < ActiveRecord::Migration
  def self.up
    create_table "invoice_addresses", :force => true do |t|
      t.integer  "order_id"
      t.string   "name"
      t.string   "street"
      t.string   "place"
      t.string   "post_code"
      t.string   "id_number"
      t.string   "vat_number"
    end
  end

  def self.down
    drop_table "invoice_addresses"
  end
end
