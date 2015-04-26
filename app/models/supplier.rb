class Supplier < ActiveRecord::Base

  # relations
  has_many :products
  has_many :supplies, :dependent => :destroy
  accepts_nested_attributes_for :supplies
  # attributes validation
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /\A(|([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))\Z/i, :multiline => false
  validates_format_of :phone, :with => /\A[+0-9 ]{5,20}\Z/i, :if => :phone_filled?
  validates_format_of :post_code, :with => /\A(|\d{3,3}\s?\d{2,2})\Z/i
  validates_format_of :url, :with=>/\A((http|ftp|https?):\/\/((?:[-a-z0-9]+\.)+[a-z]{2,}))\Z/,:if => :url_filled?, :multiline => false
  # behavior of pagination
  cattr_reader :per_page
  @@per_page = 3
  default_scope { order('id DESC') }

  # methods for helping with validation
  def phone_filled?
    !phone.blank?
  end

  def url_filled?
    !url.blank?
  end

end
