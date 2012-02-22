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

  # /admin/orders/:id/nextstate
  member_action :nextstate, :method => :put do
    @order = Order.find(params[:id])
    @order.set_next_state
    respond_to do |format|
      format.js { render "nextstate", :layout => false }
    end
  end

  controller do
    def destroy
      flash[:error] = 'Objednávku nelze smazat'
      redirect_to :action => :index
    end
    def update
       @order = Order.find(params[:id])
       state = params[:order][:state] if params[:order][:state] != @order.state
       params[:order].delete :state
       @order.update_attribute(:state, state) if state
       update!
    end
  end

  actions :all, :except => :destroy

  index do
    column :customer
    column :sum do |order|
      div :class => "sum" do
        number_to_currency order.sum
      end
    end
    column :created_at do |order|
      date_in order
    end

    column :payment_method do |order|
      order.pm_name
    end

    column :message do |order|
      order.message.blank? ? 'NE' : 'ANO'
    end

    default_actions
  end

  show do
    panel "Podrobnosti" do
      attributes_table_for order do
        row(:created_at) { date_in order }
        row('Celková suma') { number_to_currency order.sum }
        row(:payment_method) {
          "#{order.payment_method.name} ~ #{number_to_currency order.payment_method.cost}"
        }
        row(:state) {
          status_tag order.state_in_words, order.state_as_symbol
        }
      end
      customer = order.customer
      panel "Zákazník" do
        attributes_table_for customer do
          row('Jméno') { link_to customer.fullname, admin_customer_path(customer) }
          row('Telefon') { customer.phone }
          row('Email') { customer.email }
        end
        panel "Adresa" do
          attributes_table_for customer do
            row('Ulice') { customer.street }
            row('Obec') { customer.place }
            row('PSČ') { customer.post_code }
          end
        end
        panel "Fakturační adresa" do
          div { simple_format order.invoice_address.name }
          div { simple_format order.invoice_address.street }
          div { simple_format order.invoice_address.place + ' ' +
                            order.invoice_address.post_code }
          div { simple_format order.invoice_address.id_number }
          div { simple_format order.invoice_address.vat_number }
        end if order.invoice_address
      end
    end if order.customer

    panel "Produkty" do
      table_for order.products do |i|
        i.column('Název') do |product|
          link_to product.title, admin_product_path(product)
        end
        i.column 'Počet kusů', :count
        i.column('Cena za všechny') do |product|
          number_to_currency product.cost
        end
      end
      div do
        strong 'Celkem'
        number_to_currency order.sum
      end
      div order.message
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "Detaily" do
      f.input :payment_method
      f.input :state, :as => :select, :collection => Order.state_options, :include_blank => false
    end
    f.inputs "Produkty" do
      f.has_many :items do |j|
        j.input :product, :as => :select, :include_blank => false
        j.input :count
        j.input :_destroy, :as => :boolean, :label => 'Odstranit'
      end
    end
    f.buttons
  end

end
