ActiveAdmin.register Product do
  menu :priority => 2
  #belongs_to :category
  scope :active

  filter :category
  filter :supplier
  filter :title
  filter :amount
  filter :price
  filter :created_at

  index do
    column :name do |product|
      link_to product.name, admin_product_path(product)
    end
    column :category
    column :supplier
    column :amount
    column :price, :sortable => :price do |product|
      div :class => "price" do
        number_to_currency product.price
      end
    end
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :description
      f.input :category
      f.input :supplier
      f.input :picture, :as => :file
    end

    f.inputs "Stock" do
      f.input :amount
      f.input :price
    end
    f.buttons
  end

end
