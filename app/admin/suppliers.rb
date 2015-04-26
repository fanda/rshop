ActiveAdmin.register Supplier do
  menu false #:parent => "Produkty", :label => 'Dodavatelé'

  filter :created_at

  index do
    column :name
    column :email
    column :phone
    column :url
    actions
  end

  form do |f|
    f.has_many :supplies do |supply|
      supply.inputs
    end
    f.inputs "Address" do
      f.input :name
      f.input :street
      f.input :place
      f.input :post_code
    end
    f.inputs "Contact" do
      f.input :phone
      f.input :email
      f.input :url
    end
    f.actions
  end

  show do
    panel "Address" do
      attributes_table_for supplier do
        row('Name') { supplier.name }
        row('Street') { supplier.street }
        row('Place') { supplier.place }
        row('Post Code') { supplier.post_code }
      end
    end
    panel "Contact" do
      attributes_table_for supplier do
        row('Phone') { supplier.phone }
        row('Email') { supplier.email }
        row('Web') { supplier.url }
      end
    end
    active_admin_comments
  end
end
