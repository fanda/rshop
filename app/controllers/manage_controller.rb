# coding: utf-8
class ManageController < ApplicationController

# index page of management area

  layout "manage"

  before_filter :require_employee
  before_filter :set_action

  def index
    @title = 'Stav obchodu'
    @info = 'Zde si můžete prohlédnout aktuální informace činnosti obchodu'
    @waiting_orders   = Order.waiting.paginate(:page=>params[:orders_page]||1)
    @waiting_supplies = Supply.paginate(:page=>params[:supplies_page]||1,
                                        :conditions => 'state = 1')
    @weekly_new_customers = Customer.weekly_new
  end
  
private

  def set_action
    @action = 'index'
  end
 
end
