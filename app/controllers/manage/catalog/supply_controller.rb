# coding: utf-8
class Manage::Catalog::SupplyController < ApplicationController

# controller for supply control in manage area
# RESTful methods are self-descriptive

  layout "manage"

  before_filter :require_employee
  before_filter :set_action
  before_filter :set_menu

  helper 'manage'
  helper 'errors'

  def index
    @supplier = Supplier.find_by_id params[:supplier_id]
    redirect_to '/404.html' unless @supplier
    @waiting  = @supplier.supplies.paginate(
                :page => params[:page]||1, :conditions => { :state => 1 } )
    @finished = @supplier.supplies.paginate(
                :page => params[:page]||1, :conditions => { :state => 2 } )
    @menu << {:title=>'Objednat zboží', :norel=>true,
              :href=>"/catalog/supplier/#{@supplier.id}/supply/new"}
    @title = "Objednávky učiněné u firmy #{@supplier.name}"    
    @info  = 'Kliknutím na \'Objednat zboží\' v levém menu, můžete u dodavatele
            objednat zboží'    
  end

  def new
    @title = 'Nová objednávka zboží do obchodu'
    @info = 'Pokud zboží nechcete objednat, ponechtejte v poli hodnotu 0'
    @supplier = Supplier.find_by_id params[:supplier_id]
    redirect_to '/404.html' unless @supplier
    @products = @supplier.products.order('id DESC')
    @menu << {:title=>'Zobrazit objednávky', :norel=>true,
              :href=>"/catalog/supplier/#{@supplier.id}/supply"}
  end

  def create
    @supplier = Supplier.find_by_id params[:supplier_id]
    redirect_to '/404.html' unless @supplier
    @supply = @supplier.supplies.new
    params[:amount].each_pair do |pid,amount|
      unless amount == '0' or Integer(amount) < 0
        unless @supply.entries.build(:quantity   => amount, 
                                     :product_id => pid )
          @error = "Objevila se chyba. Zkontrolujte dané hodnoty."
          break
        end
      end
    end
    unless @error
      delivery_date = Date.civil(params[:date][:year].to_i,
                                 params[:date][:month].to_i,
                                 params[:date][:day].to_i)
      @supply.delivered_at = delivery_date
      @supply.state = 1
      @supply.employee = current_employee
      @supply.save
      #SupplierMailer.order(@record, @product_and_amount)    
    end
  end

  def show
    @supplier = Supplier.find_by_id params[:supplier_id]
    redirect_to '/404.html' unless @supplier
    @supply = @supplier.supplies.find_by_id params[:id]
    render :layout => false   
  end

  def edit
    @supplier = Supplier.find_by_id params[:supplier_id]
    @supply   = @supplier.supplies.find_by_id params[:id]
    @entries  = @supply.entries
  end

  def update 
    @supplier = Supplier.find_by_id params[:supplier_id]
    @supply = @supplier.supplies.find_by_id params[:id]
    params[:amount].each_pair do |pid, amount|
      if Integer(amount) > 0
        product = @supplier.products.where(:id => pid).first
        quantity = product.amount + Integer(amount)
        unless product.update_attribute(:amount, quantity)
          @error = 'Objevila se chyba. Zkontrolujte dané hodnoty.'
        end
      end
    end
    if @error 
      @entries  = @supply.entries
      render :action => 'edit'
    else
      @supply.delivered_at = Time.now
      @supply.state = 2      
      @supply.save
      redirect_to manage_catalog_supplier_path @supplier
    end
  end

  def destroy
    record = Supplier.find_by_id params[:id]
    redirect_to '/404.html' unless record
    record.destroy
    respond_to do |format|  
      flash[:error] = "Supplier was removed"          
      format.html {         
        redirect_to :controller => 'manage/catalog'
      }
      format.js {
        render :js => "window.location.href = \'./catalog\';"
      }            
    end
  end


private

  def set_action
    @action = 'catalog'
  end

  def set_menu
    @menu = [{:title=>'Detaily dodavatele',  :norel=>true,
              :href=>"/catalog/supplier/#{params[:supplier_id]}"},
             {:title=>'Dodavatelé', :norel=>true,
              :href=>'/catalog/supplier'}]
  end

end

