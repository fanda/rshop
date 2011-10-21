# coding: utf-8
class Manage::InvoicesController < ApplicationController

  layout "manage"
  helper 'manage'

  before_filter :require_employee, :set_action
  before_filter :find_invoice, :except => [:index, :new, :create]

  def index
  end

  def show
    @items = @invoice.items
    @customer = @order.customer
    if @invoice.forma == Invoice::STORNO
      begin
        @normal_forma_id = @order.invoices.find_by_forma(Invoice::NORMAL).number
      rescue
        @normal_forma_id = ''
      end
    end
    set_menu    
    
    layout = params[:print] == '1' ? 'print' : 'manage'
    render :layout => layout, :template => @invoice.template_name
  end

  def new
    @order = Order.find params[:order_id]
    if params[:forma] == 'storno'
      count = Invoice.count_storno
    else
      count = Invoice.count_normal
    end
    @invoice = @order.invoices.build({
      :number => count + 1, 
      :created_at => Time.now
    })
    @items = @order.items
    no_layout_if_xhr_request
  end

  def create
    @order = Order.find params[:order_id]
    if @invoice = @order.invoices.create(params[:invoice])
      @invoice.save_items(params[:items])
      flash[:success] == 'Faktura vytvořena'
      redirect_to manage_order_invoice_path(@order.id, @invoice.id)
    else
      render :action => 'new'
    end
  end

  def edit
    @items = @order.items
    @invoice_items = @invoice.items
    no_layout_if_xhr_request
  end

  def update
    if @invoice.update_attributes(params[:invoice]) and 
       @invoice.save_items params[:items]
      redirect_to manage_order_invoice_path(@order.id, @invoice.id)
    else
      render :action => 'new'
    end
  end

  def destroy
    @invoice.delete
    redirect_to manage_order_path(@order.id)
  end

protected

  def set_menu
    @menu = [
    { :title=>'Tisk faktury',  
      :href=>manage_order_invoice_path(@order.id,@invoice.id, :print=>1), 
      :norel => true, :noprefix => true
    },
    { :title=>'Upravit fakturu', 
      :href=>edit_manage_order_invoice_path(@order.id,@invoice.id), 
      :noprefix => true
    },
    { :title=>'Vytvořit novou fakturu', 
      :href=>new_manage_order_invoice_path(@order.id), 
      :noprefix => true
    },
    { :title=>'Smazat', 
      :href=>manage_order_invoice_path(@order.id,@invoice.id), 
      :noprefix => true, :method => :delete
    }]
  end

  def find_invoice
    @order = Order.find params[:order_id]
    @invoice = @order.invoices.find params[:id]
    @title = "Faktura č. " + @invoice.number
  end

  def set_action
    @action = 'orders'
  end

end
