# coding: utf-8
ActiveAdmin.register Customer do
  menu :parent => 'Uživatelé', :label => 'Zákazníci'

  filter :name, :label => 'Jméno'
  filter :surname, :label => 'Příjmení'
  filter :email, :label => 'Email'
  filter :phone, :label => 'Telefon'
  filter :created_at, :label => 'Datum registrace'
  filter :street
  filter :place, :label => 'Obec'
  filter :post_code, :label => 'PSČ'

  index do
    column :name
    column :phone
    column :email
    column :orders do |customer|
      customer.orders.size.to_s
    end
    default_actions
  end

  form do |f|
    f.inputs "Detaily" do
      f.input :name
      f.input :surname
      f.input :phone
      f.input :email
    end
    f.inputs "Adresa" do
      f.input :street
      f.input :place
      f.input :post_code
    end
    f.buttons
  end

  show do
    panel "Detaily" do
      attributes_table_for customer do
        row(:fullname) { customer.fullname }
        row(:phone) { customer.phone }
        row(:email) { customer.email }
      end
    end
    panel "Adresa" do
      attributes_table_for customer do
        row(:street) { customer.street }
        row(:place) { customer.place }
        row(:post_code) { customer.post_code }
      end
    end
    active_admin_comments
  end
end
