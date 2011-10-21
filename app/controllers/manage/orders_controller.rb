# coding: utf-8
class Manage::OrdersController < ApplicationController

# controller for managing orders

  layout "manage"
  helper 'manage'

  before_filter :require_employee
  before_filter :set_action
  before_filter :set_menu

  # shows lists of waiting and finished orders
  def index
    @title = 'Výpis objednávek zákazníků'
    @info = 'Stav objednávek změníte kliknutím na příslušnou ikonku v tabulkce' 
    if flash[:success]
      @info = flash[:success]
    end
    
    @waiting  = Order.waiting.paginate(:page=>params[:page]||1)
    @finished = Order.finished.paginate(:page=>params[:fin_page]||1) 
  end

  # shows ONE orders
  def show
    @title = 'Podrobnosti o objednávce'
    @record = Order.find_by_id params[:id]
    @customer = @record.customer
    redirect_to '/404.html' unless @record
    no_layout_if_xhr_request
  end

  def note
    @record = Order.find_by_id params[:id]
    @record.update_attribute(:note, params[:note]||' ')
    render :partial => 'ajax_note'
  end
  
  def item_note
    @record = Item.find_by_id params[:id]
    @record.update_attribute(:note, params[:note]||' ')
    render :text => nil
  end

  # switches status of order - AJAX
  def state
    @record = Order.find_by_id params[:id]
    @record.update_attribute(:state, params[:state]||'')
    if @record.state == Order::PAID
      @record.invoices.create({
        :number => Invoice.count_normal + 1, :forma => Invoice::NORMAL
      })
    end
    #render :partial => 'ajax_note'
    render :text => 'nil'
  end

  # switches status of order
  def status
    @title = 'Změna stavu objednávky'
    @record = Order.find_by_id params[:id]
    if params[:order]
      success = errors = ''
      if @record.state.to_s != params[:order][:state]
        if @record.update_attribute(:state, params[:order][:state])
          success += 'Stav objednávky změněn. '
          if @record.state == Order::PAID
            @record.invoices.create({
              :number => Invoice.count + 1, :forma => Invoice::NORMAL
            })
          end
        else
          errors += 'Nelze změnit stav objednávky. '
        end
      end
      if @record.update_attribute(:note, params[:order][:note])
        success += 'Poznámka uložena.'
      else
        errors += 'Poznámka nešla uložit.'
      end
      flash[:success] = success unless success.blank?
      flash[:error] = errors unless errors.blank?
    end
    #redirect_to :action => 'index'
  end

  # shows only waiting orders
  def waiting
    @title = 'Objednávky čekající na potvrzení'
    @info = 'Stav objednávky změníte kliknutím na příslušnou ikonku v tabulce'
    @waiting  = Order.waiting.paginate(:page=>params[:page]||1, :per_page => 20)
  end

  # shows only finished orders
  def finished
    @title = 'Potvrzené objednávky'
    @info = 'Stav objednávky změníte kliknutím na příslušnou ikonku v tabulce'
    @finished = Order.paginate(:page=>params[:fin_page]||1, :per_page => 20,
              :order=>'id DESC', :conditions => { :state => Order::FINISHED } )
  end

  def invoice_address
    @order = Order.find_by_id params[:id]
    @invoice_address = @order.invoice_address
    if request.post?
      if @invoice_address
        @invoice_address.update_attributes(params[:invoice_address])
      else
        @order.create_invoice_address(params[:invoice_address])
      end
      redirect_to :action => 'show', :id => @order.id
    end
  end

private
  
  # default menu for this controller
  def set_menu
    @menu = [
    { :title=>'Nedokončené objednávky',  
      :href=>'/orders/waiting', :norel => true
    },
    { :title=>'Dokončené objednávky', 
      :href=>'/orders/finished', :norel => true
    }]
  end

  def set_action
    @action = 'orders'
  end

end
