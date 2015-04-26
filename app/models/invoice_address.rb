class InvoiceAddress < ActiveRecord::Base

  belongs_to :order

  attr_accessible :name, :street, :place, :post_code, :id_number, :vat_number

  validates_format_of :post_code, :with => /\A(|(\d{3,3}\s?\d{2,2}))\Z/i


  def is_blank?
  end

end
