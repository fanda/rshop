# coding: utf-8
# CustomerController defines customer actions
class CustomerController < ApplicationController

  before_filter :require_no_user, :only => [:new,:create,:login]
  before_filter :require_user, :assign_customer, :only => [:edit,:update,:logout,:order,:bill,:index,:password]

  before_filter :right_side_content

#
#  CREATING AND LOGGING
#

  # login customer
  def login
    @title = 'Přihlášení zákazníka'
    if request.post?
      control = Action.control_record params[:pin][0..8]
      if control.can_check_pin?
        odorik = Odorik.new params[:pin]
        if odorik.user_exists?
          @customer_session = CustomerSession.new({
              :login    => params[:pin][0..8],
              :password => params[:pin],
              :remember_me => params[:remember_me]
          })
          if @customer_session.save
            if cookies[:cart]
              order = Order.find cookies[:cart]
              unless order.items.empty?
                user = Customer.find_by_login params[:pin][0..8]
                unless order == user.order_in_cart
                  user.order_in_cart.delete
                  user.orders << order
                end
              end
            end
          end
          redirect_to :action => :index
        else
          flash[:error] = 'Nesprávný PIN'
          redirect_to :action => :login
        end
      else
        flash[:error] = 'Příliš mnoho nesprávných pokusů za sebou'
        redirect_to :action => :login
      end
    else 
      @customer_session = CustomerSession.new
    end
    no_layout_if_xhr_request        
  end

  # logout customer
  def logout
    cookies.delete :cart
    current_user_session.destroy
    flash[:success] = "Odhlášení úspěšné"
    redirect_to '/'
  end

  def new
    @customer = Customer.new
    @title='Registrace zákazníka'    
  end

  # create new customer
  def create
    @title='Registrace zákazníka'
    @customer = Customer.new(params[:customer])
    if @customer.save
      flash[:success] = "Registrace úspěšná"
      redirect_back_or_default '/customer'
    else
      render :action => :new
    end
  end


#
#   USER's
#


  # show customer page, orders, cutomer entries
  def index
    @page = params[:order_page] || 1
    @title = 'Můj zákaznický účet v obchodě'
    @orders = @customer.orders.paginate(:page=>@page)
  end

  # edit customer entries
  def edit
    @title='Úprava informací o mně'
    no_layout_if_xhr_request
  end

  # update customer entries
  def update
    if @customer.update_attributes(params[:customer])
      flash[:success] = "Nastavení přijato"
      redirect_to :action => 'index'
    else
      render :action => :edit
    end
  end

  # show bill of order
  def bill
    @order = @customer.orders.find params[:id]
    @items = @order.items
    @title = "Tisk faktury č. #{@order.id}"
    render :layout => 'print'
  end

  # show one order
  def order
    @order = @customer.orders.find params[:id]
    @items = @order.items
    @title = "Objednávka č. #{@order.id}"    
    no_layout_if_xhr_request
  end


protected
  
  def assign_customer
    @customer = current_user
  end  

end
