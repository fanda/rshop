# coding: utf-8
# CartController defines actions for managing with cart and products in cart
class CartController < ApplicationController

  before_filter :set_order, :except => [:submit]

  def index
    @title = "Košík"
    @products = @order.products
  end

  # clean products from cart
  def clean
    @order.remove_all_items
    redirect_to :action => 'index'
  end

  def edit
    if params[:id]
      @product = Product.find params[:id]
      @item = @product.items.in @order
      if @item
        render :partial => 'form'
      else
        @error = 'Produkt nenalezen'
        render :partial => 'errors'
      end
    else
      @error = "Nezadán produkt!"
      render :partial => 'errors'
    end
  end

  # edit amount product in cart
  def update
    if params[:id]
      @product = Product.find params[:id]
      if params[:amount]
        amount = params[:amount].to_i
        @new_price = @order.update_item @product, amount
        respond_to do |format|
          format.html { redirect_to :action => 'index'   }
          format.js   { render :partial => 'ajax_update' }
        end
      end
    else
      @error = "Nezadán žádny produkt!"
      render :partial => 'errors'
    end
  end

  # remove product from cart
  def remove
    item = Product.find(params[:id]).items.in @order
    redirect_to '/404.html' unless item
    item.delete
    @order.actualize_sum
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js   {
        if @order.sum == 0
          render :js => 'window.location.reload();'
        else
          render :partial => 'ajax_remove'
        end
      }
    end
  end

  # insert product to cart
  def add
    if params[:id]
      product = Product.find params[:id]
      if product.available?
        @order.add_item product
        @order.actualize_sum
        redirect_to :action => 'index'
      else
        redirect_to catalog_product_path product.category, product
      end
    else
      redirect_to '/404.html'
    end
  end

  def review
    if @order.items.count == 0
      flash[:error] = 'Není co objednávat'
      redirect_to cart_path
    end
    @order.customer = current_user || Customer.new
    @order.build_invoice_address
    unless @order and @products = @order.products
      @error = "Objednávka neexistuje. Kontaktujte správce."
    end
  end

  # submit order
  def submit
    render_page_not_found unless params[:order]

    @order = Order.find(params[:order][:id])

    unless @order.cart?
      render :action => 'error'
      return
    end

    customer_attributes = params[:order][:customer_attributes]

    if customer = current_user
      customer.update_attributes customer_attributes
    elsif email = params[:order][:customer_attributes][:email]
      if customer = Customer.find_by_email(email)
        customer.update_attributes customer_attributes
      else
        password = ActiveSupport::SecureRandom.base64(6)
        customer_attributes[:password] = password
        customer = Customer.create customer_attributes
        sign_in customer
        if customer.id?
          OrderMailer.new_customer(customer, password).deliver
          @new_record = true
        end
      end
    end

    @order.customer = customer
    #@order.update_invoice_address params[:order][:invoice_address_attributes]
    params[:order].delete :customer_attributes
    #params[:order].delete :invoice_address_attributes

    if @order.submit(params[:order]) and @order.customer.errors.blank?

      cookies.delete :cart

      OrderMailer.new_order(customer, @order).deliver
      OrderMailer.review_order(customer, @order).deliver

      render :action => 'thanks'
    else
      #@order.build_invoice_address unless @order.invoice_address?
      @again = true
      @products = @order.products
      render :action => :review
    end
  end

protected

  def set_order
    if current_user
      @order = current_user.order_in_cart

    elsif cookies[:cart]
      @order = Order.find cookies[:cart]

    else
      @order = Order.create!
      # 604800 == 1 tyden
      cookies[:cart] = { :value => @order.id, :expires => Time.now + 604800 }
    end
  end

  def create_invoice_address_if_not_empty
    attributes = :invoice_address_attributes
    params[:order][attributes].each do |a|
      return InvoiceAddress.new(params[:order][attributes]) unless a==''
    end

  end

end
