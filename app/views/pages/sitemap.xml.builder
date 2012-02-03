xml.instruct!

xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.9" do
  xml.url do
    xml.loc         "#{@index}/"
    xml.lastmod     sitemap_date(Time.now)
    xml.changefreq  "daily"
    xml.priority    1.0
  end
  @pages.each do |p|
    xml.url do
      xml.loc         "#{@index}/#{p.url}"
      xml.lastmod     sitemap_date(p.updated_at)
      xml.changefreq  "monthly"
      xml.priority    0.5
    end
  end
  xml.url do
    xml.loc         "#{@index}/kontakt"
    xml.lastmod     sitemap_date(Time.now.beginning_of_month)
    xml.changefreq  "monthly"
    xml.priority    0.5
  end
  @categories.each do |p|
    xml.url do
      xml.loc         "#{@index}/kategorie/#{p.slug}"
      xml.lastmod     sitemap_date(p.updated_at)
      xml.changefreq  "weekly"
      xml.priority    0.7
    end
  end
  @products.each do |p|
    xml.url do
      xml.loc         "#{@index}#{sitemap_product_path(p)}"
      xml.lastmod     sitemap_date(p.updated_at)
      xml.changefreq  "weekly"
      xml.priority    0.9
    end
  end
end
