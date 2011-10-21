# coding: utf-8
class Manage::CatalogController < ApplicationController

# Default page for managing catalog

  layout "manage"
  helper 'manage'

  before_filter :require_employee
  before_filter :set_action

  # only show categories, products and suppliers
  def index
    @title = 'Katalog obchodu'
    if flash[:success]
      @info = flash[:success]
    else
      @info = 'Pro zobrazení detailů o dodavateli, klikněte na řádek tabulky'
    end

    @menu = [
    {:title=>'Produkty',  :href=>'/catalog/product',  :norel=>true},
    {:title=>'Kategorie', :href=>'/catalog/category', :norel=>true},
    {:title=>'Dodavatelé',:href=>'/catalog/supplier', :norel=>true},
    {:title=>'Přidat produkt',    :href=>'/catalog/product/new' },
    {:title=>'Přidat kategorii',  :href=>'/catalog/category/new'},
    {:title=>'Přidat dodavatele', :href=>'/catalog/supplier/new'}]

    @categories = Category.paginate(:page=>params[:cat_page]||1)
    @suppliers  = Supplier.paginate(:page=>params[:sup_page]||1)
    @products   = Product.paginate(:page=>params[:pro_page]||1)

  end

private

  def set_action
    @action = 'catalog'
  end

end
