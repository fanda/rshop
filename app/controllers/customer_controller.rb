# coding: utf-8
# CustomerController defines customer actions
class CustomerController < ApplicationController

  before_filter :authenticate_customer!, :assign_customer, :only => [:edit,:update,:logout,:order,:bill,:index,:password]

  before_filter :right_side_content

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
