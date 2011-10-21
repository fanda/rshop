# coding: utf-8
class Manage::Catalog::CategoryController < ApplicationController

# controller for category control in manage area
# RESTful methods are self-descriptive

  layout "manage"

  before_filter :require_employee
  before_filter :set_action

  def index
    
    if flash[:success]
      @info = flash[:success]
    end
    @title = 'Výpis kategorií'

    @menu = [
    {:title=>'Přidat kategorii',  :href=>'/catalog/category/new'},
    {:title=>'Zobrazit produkty', :href=>'/catalog/product', :norel=>true},
    {:title=>'Zobrazit dodavatele',:href=>'/catalog/supplier',:norel=>true},
    {:title=>'Import kategorií',:href=>'/catalog/category/import',:norel=>true},
    {:title=>'Export kategorií',:href=>'/catalog/category/export',:norel=>true}]
        
    @categories = Category.roots.paginate(:page=>params[:cat_page]||1)
  end

  def new
    @record = Category.new
    render :partial => "form"
  end

  def create
    if params[:category]
      @record = Category.new(params[:category])
      if @record.save
        flash[:success] = "Kategorie vytvořena"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Vytvoření selhalo"
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
    @title = 'Detaily kategorii'
    @record = Category.find_by_id params[:id]
    redirect_to '/404.html' unless @record
  end

  def edit
    @record = Category.find_by_id params[:id]
    render :partial => 'form'
  end

  def update 
    if params[:category] and params[:id]
      @record = Category.find_by_id params[:id]
      if @record.update_attributes params[:category]
        flash[:success] = "Kategorie upravena"
        respond_to do |format|
          format.js { 
            render :js => "window.location.reload();"
          }
          format.html { render :action => 'index' }
        end
      else
        respond_to do |format|            
          format.html { 
            flash[:error] = "Kategorie nebyla upravena"
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
    record = Category.find_by_id params[:id]
    redirect_to '/404.html' unless record
    record.products.each do |p|
      p.update_attribute(:category_id, nil)
    end
    record.destroy
    respond_to do |format|  
      flash[:error] = "Kategorie odstraněna"          
      format.html {         
        redirect_to :controller => '/manage/catalog' 
      }
      format.js {
        render :js => "window.location.href = \'./catalog\';"
      }            
    end
  end

  def sort
    Category.all.each do |category|
      if position = params[:categories].index(category.id.to_s)
        unless category.position == position + 1
          category.update_attribute(:position, position + 1) 
        end
      end
    end
    render :nothing => true, :status => 200
  end

  # exports categories to XML
  def export
    render :xml => Category.all
  end

  # imports categories from XML
  def import
    if request.post?
      unless params[:file] 
        @error = 'Nebyl vybrán soubor pro import'
      else  
        #@categories = Category.all
        counter = 0
        require 'nokogiri'
        xdoc = Nokogiri::XML(params[:file].read)
        xdoc.xpath('//category').each do |node|
          if node.element?
            category = {}
            node.element_children.each do |c|
              category[c.name] = c.content.gsub(/[\n]+/, '')
            end
            c = Category.new category
            if c.save
              counter += 1
            end
          end
        end        
        flash[:success] = 'Úspěšně importované kategorie: ' + counter.to_s        
        redirect_to '/manage/catalog/category'
      end
    end
  end

private

  def set_action
    @action = 'catalog'
    @info = 'Kategorie umožňují třídit zboží podle jeho vlastností'
  end

end
