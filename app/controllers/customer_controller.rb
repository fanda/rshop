# coding: utf-8
# CustomerController defines customer actions
class CustomerController < ApplicationController

  before_filter :authenticate_customer!, :assign_customer,
                :only => [:order,:bill,:index]

  before_filter :set_order

  # show customer page, orders, cutomer entries
  def index
    @page = params[:order_page] || 1
    @title = 'Můj zákaznický účet v obchodě'
    @orders = @customer.orders.page(@page)
  end

  # show bill of order
  def bill
    @order = @customer.orders.find params[:id]
    @products = @order.products
    @title = "Tisk faktury č. #{@order.id}"
    render :layout => 'print'
  end

  # show one order
  def order
    @order = @customer.orders.find params[:id]
    @products = @order.products
    @title = "Objednávka č. #{@order.id}"
    no_layout_if_xhr_request
  end


protected

  def assign_customer
    @customer = current_customer
  end

end
