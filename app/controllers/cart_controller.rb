# coding: utf-8
# CartController defines actions for managing with cart and products in cart
class CartController < ApplicationController

  helper :errors

  before_filter :right_side_content
  before_filter :set_order, :except => [:submit, :odorik, :thanks]
  before_filter :require_user, :only => [:thanks]

  def index
    @title = "Košík"
    @items = @order.items
  end

  # clean products from cart
  def clean
    @order.remove_all
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
    @customer = current_user || Customer.new
    unless @order and @items = @order.items
      @error = "Objednávka neexistuje. Kontaktujte správce."
    end
  end

  # submit order
  def submit
    redirect_to '/404.html' unless params[:customer] and params[:order]

    if params[:pin]
      # PIN zadan
      odorik = Odorik.new params[:pin]
      if odorik.user_exists? #@customer
        pin = params[:pin]
        if Customer.find_by_login pin[0..8]
          # uzivatel je v Odoriku i v eshopu
          customer_session = CustomerSession.new({
            :login    => pin[0..8],
            :password => pin
          })
          if customer_session.save
            @customer = current_user
            @customer.update_attributes(params[:customer])
            @customer.order_in_cart.delete if @customer.has_cart?
          end
        else
          # uzivatel je v Odoriku ale ne v eshopu
          @new_record = true
          params[:customer][:login]    = pin[0..8]
          params[:customer][:password] = pin
        end
      else
        # uzivatel neni v Odoriku ani v eshopu
        @new_record = true
      end
    else
      # PIN nezadan
      @new_record = true
      if params[:customer][:email]
        pin = Odorik.find_pin_by_email params[:customer][:email]
        if pin
          # PIN nalezen na zaklade emailu
          if @customer = Customer.find_by_login(pin[0..8])
            # uzivatel je v Odoriku i v eshopu
            @customer.update_attributes(params[:customer])
            @new_record = false
          else
            # uzivatel je v Odoriku ale ne v eshopu
            params[:customer][:login] = pin[0..8]
            params[:customer][:password] = pin
          end
        end
      end
    end

    if @new_record # vytvoreni noveho uzivatele
      @customer = Customer.create params[:customer]
      OrderMailer.new_customer(@customer, @pass).deliver
    end

    @order = Order.find(params[:order][:id])

    if @customer and @customer.errors.blank?
      cookies.delete :cart
      @customer.orders << @order.submit(params[:order][:message])
      @order.create_invoice_address(params[:invoice_address]) if invoice_address_filled?
      OrderMailer.new_order(@customer, @order).deliver
      OrderMailer.review_order(@customer, @order).deliver
      render :action => 'thanks'
    else
      @customer = Customer.new(params[:customer]) unless @customer
      @again = true
      @items = @order.items
      render :action => :review
    end
  end

  def odorik
    return unless request.xhr?
    control = Action.control_record params[:opin][0..8]
    if control.can_check_pin?
      odorik = Odorik.new params[:opin]
      if odorik.user_exists?
        @user_info = odorik.user_info
        customer_session = CustomerSession.new({
          :login    => params[:opin][0..8],
          :password => params[:opin]
        })
        if customer_session.save
          render :partial => 'ajax_odorik_with_session'
        else
          render :partial => 'ajax_odorik_without_session'
        end
      else
        @error = 'Zadaný PIN nesouhlasí s žádným uživatelem. Zadejte adresu ručně.'
        render :partial => 'ajax_odorik_error'
      end
      control.increment_counter
    else
      @error = 'Překročen povolený počet pokusů. Zadejte adresu ručně.'
      render :partial => 'ajax_odorik_error'
    end
  end

protected

  def put_new_password_into_params
     params[:customer][:password] = @pass = rand(36**6).to_s(36)
  end

  def invoice_address_filled?
    params[:invoice_address].values.each do |v|
      return true unless v.blank?
    end
    false
  end

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

end
