class Entry < ActiveRecord::Base

  # relations
  belongs_to :supply
  belongs_to :product

  # attributes validation
  validates_presence_of :quantity
  validates_numericality_of :quantity, :greater_than_or_equal_to => 1

end
