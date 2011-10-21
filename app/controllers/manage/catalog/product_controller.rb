# coding: utf-8
class Manage::Catalog::ProductController < ApplicationController

# controller for products control in manage area
# RESTful methods are self-descriptive

  layout "manage"

  before_filter :require_employee
  before_filter :set_action

  def index
    if flash[:success]
      @info = flash[:success]
    end
    @title = 'Výpis zboží'

    @menu = [
    {:title=>'Přidat produkt',    :href=>'/catalog/product/new'},
    {:title=>'Zobrazit kategorie',:href=>'/catalog/category',:norel=>true},
    {:title=>'Zobrazit dodavatele',:href=>'/catalog/supplier',:norel=>true}]

    @products = Product.paginate(:page=>params[:cat_page]||1,
    :order=>'id DESC', :per_page => 20)
  end

  def new
    @record = Product.new
    render :partial => "form"
  end

  def create
    if params[:product]
      @record = Product.new(params[:product])
      unless params[:picture_url].blank?
        @record.picture_from_url params[:picture_url]
      end
      if @record.save
        flash[:success] = "Product saved"
        respond_to do |format|
          format.js {
            render :js => "window.location.reload();"
          }
          format.html { redirect_to :action => 'index' }
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = "Product was not saved"
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
    @title = 'Zobrazení zboží'
    @record = Product.find_by_id params[:id]
    redirect_to '/404.html' unless @record
  end

  def edit
    @record = Product.find_by_id params[:id]
    render :partial => 'form'
  end

  def update
    if params[:product] and params[:id]
      @record = Product.find_by_id params[:id]
      unless params[:picture_url].blank?
        params[:product][:picture] = @record.picture_from_url params[:picture_url]
      end
      if @record.update_attributes params[:product]
        flash[:success] = "Product edited"
        redirect_to :action => 'index'
      end
    else
      redirect_to '/404.html'
    end
  end

  def destroy
    record = Product.find_by_id params[:id]
    redirect_to '/404.html' unless record
    record.update_attribute(:active, 0)
    record.items.each do |item|
      if item.order.state == 0
        item.order.items.delete item
      end
    end
    respond_to do |format|
      flash[:error] = "Product was removed"
      format.html {
        redirect_to :controller => 'manage/catalog'
      }
      format.js {
        render :js => "window.location.href = \'./catalog\';"
      }
    end
  end

  def sort
    Product.all.each do |product|
      if position = params[:products].index(product.id.to_s)
        unless product.position == position + 1
          product.update_attribute(:position, position + 1)
        end
      end
    end
    render :nothing => true, :status => 200
  end


private

  def set_action
    @action = 'catalog'
    @info = 'Produkty v systému'
  end

end
