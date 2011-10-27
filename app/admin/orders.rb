ActiveAdmin.register Order do
  menu :priority => 4

  filter :sum
  filter :state_in_words
  filter :created_at

  # /admin/orders/:id/items
  member_action :items do
    @order = Order.find(params[:id])

    # This will render app/views/admin/posts/comments.html.erb
  end


  index do
    column :customer
    column :sum, :sortable => :sum do |order|
      div :class => "sum" do
        number_to_currency order.sum
      end
    end
    column :created_at
    column :state
    column :message
    column :note
    default_actions
  end

  show do
    panel "Customer" do
      table_for order.customer do |i|
        i.column :name
        i.column :surname
        i.column :phone
        i.column :email
      end
    end if order.customer
    panel "Address" do
      table_for order.customer do |i|
        i.column :street
        i.column :place
        i.column :post_code
      end
    end if order.customer
    panel "Products" do
      table_for order.products do |i|
        i.column('Name') do |product|
          link_to product.title, admin_product_path(product)
        end
        i.column :count
        i.column :cost do |product|
          number_to_currency product.cost
        end
      end
      div order.message
    end
    panel "Invoice address" do
      table_for order.invoice_address do |i|
        i.column :name
        i.column :street
        i.column :place
        i.column :post_code
        i.column :id_number
        i.column :vat_number
      end
    end if order.invoice_address
    active_admin_comments
  end


end
