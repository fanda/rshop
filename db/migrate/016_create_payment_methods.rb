class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.integer :cost
      t.text :info

      t.timestamps
    end
    add_column :orders, :payment_method_id, :integer
    add_index  :orders, :payment_method_id
  end
end
