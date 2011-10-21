class Item < ActiveRecord::Base

  # relations
  belongs_to :order
  belongs_to :product, :include => :category

  # attributes validation
  validates_presence_of :amount, :price
  validates_numericality_of :price,  :greater_than_or_equal_to => 0
  validates_numericality_of :amount, :greater_than_or_equal_to => 1


end
