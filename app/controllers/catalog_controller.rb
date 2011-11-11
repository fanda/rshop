# coding: utf-8
class CatalogController < ApplicationController

  respond_to :xml

  def index
    @pparam = :page
    @page = params[@pparam]||1
    @products = Product.active.paginate(:page => @page, :per_page => 5)
  end

  def show
    if @category = Category.find(params[:id])
      @title = @category.title
      @meta_desc = 'Kategorie ' + @title
      @pparam = :cat_page
      @page = params[@pparam]||1
      @products = @category.products.active.paginate(:page=>@page)
    else
      redirect_to '/404.html'
    end
  end

  def export
    @products = Product.active
    respond_to do |format|
      format.xml {render :layout => false }
    end
  end

end
