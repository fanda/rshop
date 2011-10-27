class Supplier < ActiveRecord::Base

  # relations
  has_many :products
  has_many :supplies, :dependent => :destroy
  accepts_nested_attributes_for :supplies
  # attributes validation
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /^(|([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))$/i
  validates_format_of :phone, :with => /^[+0-9 ]{5,20}$/i, :if => :phone_filled?
  validates_format_of :post_code, :with => /^(|\d{3,3}\s?\d{2,2})$/i
  validates_format_of :url, :with=>/^((http|ftp|https?):\/\/((?:[-a-z0-9]+\.)+[a-z]{2,}))/,:if => :url_filled?
  # behavior of pagination
  cattr_reader :per_page
  @@per_page = 3
  default_scope :order => 'id DESC'

  # methods for helping with validation
  def phone_filled?
    !phone.blank?
  end

  def url_filled?
    !url.blank?
  end

end
