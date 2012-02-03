module PagesHelper

  def sitemap_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  def sitemap_product_path(product)
    begin
      catalog_product_path(product.category.friendly_id,product.friendly_id)
    rescue
      product_path(product.friendly_id)
    end
  end

end
