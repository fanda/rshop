ActiveAdmin.register Customer do
  menu :parent => 'Users'

  filter :name
  filter :surname
  filter :email
  filter :phone
  filter :created_at
  filter :street
  filter :place
  filter :post_code

  index do
    column :name
    column :phone
    column :email
    column "Orders" do |customer|
      customer.orders.count
    end
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :surname
      f.input :phone
      f.input :email
    end
    f.inputs "Address" do
      f.input :street
      f.input :place
      f.input :post_code
    end
    f.buttons
  end

  show do
    panel "Details" do
      attributes_table_for customer do
        row('Name') { customer.name }
        row('Surname') { customer.surname }
        row('Phone') { customer.phone }
        row('Email') { customer.email }
      end
    end
    panel "Address" do
      attributes_table_for customer do
        row('Street') { customer.street }
        row('Place') { customer.place }
        row('Post code') { customer.post_code }
      end
    end
    active_admin_comments
  end
end
