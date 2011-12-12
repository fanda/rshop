# coding: utf-8
class CatalogController < ApplicationController

  respond_to :xml

  def index
    @pparam = :page
    @page = params[@pparam]||1
    @products = Product.active.page(@page).per(8)
  end

  def show
    if @category = Category.find(params[:id])
      @title = @category.title
      @meta_desc = 'Kategorie ' + @title
      @pparam = :page
      @page = params[@pparam]||1
      @products = Product.all_active_in(@category).page(@page).per(12)
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
