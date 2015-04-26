class Item < ActiveRecord::Base

  # relations
  belongs_to :order
  belongs_to :product

  # attributes validation
  validates_presence_of :count, :cost
  validates_numericality_of :cost,  :greater_than_or_equal_to => 0
  validates_numericality_of :count, :greater_than_or_equal_to => 1

  before_validation :update_cost
  after_save 'self.order.actualize_sum'
  before_destroy 'self.order.items.delete self', 'self.order.actualize_sum'

  attr_accessible :count, :cost, :product

  def count=(amount)
    write_attribute(:count, amount.to_i)
  end

  def update_cost
    self.cost = self.product.price * self.count
  end

end
