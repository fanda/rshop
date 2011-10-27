class Item < ActiveRecord::Base

  # relations
  belongs_to :order
  belongs_to :product

  # attributes validation
  validates_presence_of :count, :cost
  validates_numericality_of :cost,  :greater_than_or_equal_to => 0
  validates_numericality_of :count, :greater_than_or_equal_to => 1


end
