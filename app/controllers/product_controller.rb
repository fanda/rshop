# coding: utf-8
class ProductController < ApplicationController

  def show
    if params[:catalog_id]
      @category = Category.find(params[:catalog_id])
      @products = @category.products.active(:limit=>4) - [@product]
      scope = @category.products
    else
      scope = Product
    end
    @product = scope.find(params[:id])||Product.find(params[:id])
    redirect_to '/404.html' unless @product
    @title = @product.title
    @meta_desc = shorten(@product.description, 11)

    @stock = @product.amount
    if @stock == 0
      suply = Supply.where(:supplier_id=>@product.supplier_id, :state=>1)
      if suply.any?
        suply.each do |s|
          if s.entries.find_by_product_id @product.id
            @available = s[:delivered_at]
            break
          end
        end # end of each loop
        if @available
          @available_msg = 'Zboží bude dostupné do '
        end
      end
    end # end of if skladem
  end

end
