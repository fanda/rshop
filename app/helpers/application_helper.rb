# coding: utf-8
module ApplicationHelper

  def display_flashes
    output = ''
    [:error, :success, :notice].each do |type|
      if flash[type]
        output << content_tag(:div, flash[type], :class => type.to_s)
      end
    end
    output.html_safe
  end

  def format_price(price)
    currency = "Kč"
    price.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1 \2')+ " "+currency
  end

  def format_invoice_price(price)
    "#{'%.2f' % price} Kč"
  end

  def dph(price_with_dph)
    price_with_dph * 0.1667
  end

  def into_cart_link(product_id)
    link_to(
      "Vložit do košíku #{image_tag('shop/add.gif', :alt => 'košík')}".html_safe,
      into_cart_path(product_id), :class=>'nodecor'
    )
  end

  def product_link(product)
    begin
      link_to product.title, catalog_product_path(product.category.id, product.id)
    rescue
      link_to product.title, product_path(product.id)
    end
  end

  def stock_messages
    [
      'Momentálně není k dispozici',
      '"Nevypisuje se nic"',
      'Do vyprodání zásob',
      'Dostupné během několika dnů'
    ]
  end

end
