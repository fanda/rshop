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
    #price.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1 \2')+ " "+currency
    "#{price} #{AppConfig.currency}"
  end

  def format_invoice_price(price)
    "#{'%.2f' % price} #{AppConfig.currency}"
  end

  def dph(price_with_dph)
    price_with_dph * 0.1667
  end

  def into_cart_image(product_id)
    link_to(
      "#{image_tag('shop/cart_add.png', :alt => 'do košíku')}".html_safe,
      into_cart_path(product_id), :class=>'nodecor', :rel => 'nofollow'
    )
  end

  def into_cart_link(product_id)
    link_to('Vložit do košíku', into_cart_path(product_id),
            :class=>'nodecor intocart', :rel => 'nofollow')
  end

  def product_linked_title(product)
    begin
      link_to content_tag(:span, product.title),
           catalog_product_path(product.category.friendly_id,product.friendly_id),
              :class => 'product-title'
    rescue
      link_to content_tag(:span, product.title), product_path(product.friendly_id),
              :class => 'product-title'
    end
  end

  def product_linked_image(product)
    begin
      link_to image_tag(product.picture.url(:square),:alt => product.title),
           catalog_product_path(product.category.friendly_id,product.friendly_id),
              :class => 'product-image'
    rescue
      link_to image_tag(product.picture.url(:square),:alt => product.title),
              product_path(product.friendly_id), :class => 'product-image'
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

  def active_category?(category)
    category == @category or category.children.include?(@category)
  end

end

module ActionView
  module Helpers
    module TextHelper
      def pluralize(count, singular, plural = nil, even_more = nil)
          "#{count || 0} " + if count == 1 || count == '1'
           singular
         elsif plural
           if [2, 3, 4].include?(count.to_i)
             plural
           elsif even_more
             even_more
           else
             plural
           end
         elsif Object.const_defined?("Inflector")
           Inflector.pluralize(singular)
         else
           singular + "s"
         end
       end
    end
  end
end
