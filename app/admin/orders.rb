# coding: utf-8
ActiveAdmin.register Order do
  menu :priority => 4, :label => 'Objednávky'

  scope :waiting, :default => true
  scope :finished
  scope :not_paid
  scope :paid
  scope :sent
  scope :cart

  filter :sum
  filter :created_at, :label => 'Datum objednání'

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
    column :created_at do |order|
      date_in order
    end
    column :state do |order|
      state_in order
    end



    column :message do |order|
       order.message
    end
    default_actions
  end

  show do
    panel "Zákazník" do
      div { simple_format order.customer.fullname, :class=> 'title' }
      div { simple_format order.customer.phone }
      div { simple_format order.customer.email }
    end if order.customer

    panel "Adresa" do
      div { simple_format order.customer.street }
      div { simple_format "#{order.customer.place} #{order.customer.post_code}" }
    end if order.customer

    panel "Produkty" do
      table_for order.products do |i|
        i.column('Název') do |product|
          link_to product.title, admin_product_path(product)
        end
        i.column :count
        i.column('Cena za všechny') do |product|
          number_to_currency product.cost
        end
      end
      div order.message
    end

    panel "Fakturační adresa" do
      div { simple_format order.invoice_address.name }
      div { simple_format order.invoice_address.street }
      div { simple_format order.invoice_address.place + ' ' +
                          order.invoice_address.post_code }
      div { simple_format order.invoice_address.id_number }
      div { simple_format order.invoice_address.vat_number }
    end if order.invoice_address
    active_admin_comments
  end


end
