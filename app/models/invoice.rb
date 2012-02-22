# coding: utf-8
class Invoice < ActiveRecord::Base

  # relations
  belongs_to :order

  NORMAL   = 0
  STORNO   = 1
  PROFORMA = 2

  FORMAS = [ 'Daňový doklad', 'Storno', 'Proforma' ]

  attr :sum

  def forma_in_words
    FORMAS[self.forma]
  end

  def template_name
    case self.forma
      when NORMAL
        '/invoice/normal'
      when STORNO
        '/invoice/storno'
      when PROFORMA
        '/invoice/proforma'
      else
        nil
    end
  end

  def save_items(items)
    i_array = items.sort.collect do |item|
      "#{item[0]}x#{item[1][:amount]}" if item[1][:include]
    end
    self.update_attribute :item_ids, i_array.compact.join('#')
  end

  def items
    return self.order.items if self.item_ids.blank?
    i_array = self.item_ids.split('#')
    i_array.collect do |i|
      id, amount = i.split('x')
      item = self.order.items.find(id)
      item.price  = item.product.price * amount.to_i
      item.amount = amount.to_i
      item
    end
  end

  def sum
    return @sum if defined?(@sum)
    @sum = self.items.inject(0){|sum,i| sum + i.price}
  end

  def self.count_normal
    Invoice.count(:conditions => ['forma = ?', NORMAL])
  end

  def self.count_storno
    Invoice.count(:conditions => ['forma = ?', STORNO])
  end

end
