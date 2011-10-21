xml.instruct!
xml.shop do
  @products.each do |product|
    xml.shopitem do
      xml.product      { xml << product.title }
      xml.description  { xml << strip_tags(product.description) }
      xml.categorytext { xml << product.category.title }
      xml.price_vat     product.price
      xml.url           catalog_product_url(product.category, product)
      xml.imgurl        root_url.chomp('/') + product.picture.url
      xml.delivery_date 2
      xml.item_type     'new'
    end
  end
end
