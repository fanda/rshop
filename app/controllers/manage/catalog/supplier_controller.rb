# coding: utf-8
class Manage::Catalog::SupplierController < ApplicationController

# controller for supplier control in manage area
# RESTful methods are self-descriptive

  layout "manage"

  before_filter :require_employee
  before_filter :set_action

  helper 'errors'

  def index
    @title = 'Seznam dodavatelů'
    if flash[:success]
      @info = flash[:success]
    else
      @info = 'Pro zobrazení detailů o dodavateli, klikněte na řádek tabulky'
    end

    @menu = [
    {:title=>'Přidat dodavatele', :href=>'/catalog/supplier/new'},
    {:title=>'Zobrazit produkty', :href=>'/catalog/product', :norel=>true},
    {:title=>'Zobrazit kategorie',:href=>'/catalog/category',:norel=>true}]
    
    @suppliers = Supplier.paginate(:page=>params[:cat_page]||1,
    :order=>'id DESC', :per_page => 20)
  end

  def new    
    @record = Supplier.new
    render :partial => "form"
  end

  def create
    if params[:supplier]
      @record = Supplier.new(params[:supplier])
      if @record.save
        flash[:success] = "Supplier saved"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Supplier was not saved"
            render :action => 'index'
          }
          format.js { render :partial => 'ajax_errors' }            
        end
      end  
    else
      redirect_to '/404.html' 
    end
  end

  def show
    @info = 'Kliknutím na \'Objednat zboží\' v levém menu, můžete u dodavatele
            objednat zboží'
    @record = Supplier.find_by_id params[:id]
    redirect_to '/404.html' unless @record
    @title = "Podrobnosti o dodavateli #{@record.name}"
    @menu = [{:title=>'Objednat zboží', :norel=>true,
              :href=>"/catalog/supplier/#{@record.id}/supply/new"}, 
             {:title=>'Zobrazit objednávky', :norel=>true,
              :href=>"/catalog/supplier/#{@record.id}/supply"},
             {:title=>'Změnit informace', 
              :href=>"/catalog/supplier/#{@record.id}/edit"}]
    @products = @record.products.paginate(:page=>params[:pro_page]||1,
                :order=>'id DESC', :per_page => 8, :conditions => 'active = 1')
  end 

  def edit    
    @info = 'Pokud přišlo všechno zboží, které jste objednali, stačí potvrdit'
    @title = 'Vložení dodaného zboží do systému'
    @record = Supplier.find_by_id params[:id]
    render :partial => 'form'
  end

  def update 
    if params[:supplier] and params[:id]
      @record = Supplier.find_by_id params[:id]
      if @record.update_attributes params[:supplier]
        flash[:success] = "Supplier edited"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Supplier was not edited"
            render :action => 'index'
          }
          format.js { render :partial => 'ajax_errors' }            
        end
      end  
    else
      redirect_to '/404.html' 
    end
  end

  def destroy
    record = Supplier.find_by_id params[:id]
    redirect_to '/404.html' unless record
    record.products.each do |p|
      p.update_attribute(:supplier_id, nil)
    end
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

end
