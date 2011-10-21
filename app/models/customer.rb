class Customer < ActiveRecord::Base
  # relations
  has_many :orders

  # attributes validation
  validates_presence_of :email, :name, :surname, :street, :place, :post_code, :phone
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /^(|([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))$/i
  validates_format_of :post_code, :with => /^(|(\d{3,3}\s?\d{2,2}))$/i
  validates_format_of :phone, :with => /^[+0-9 ]{5,20}$/i, :if => :phone_filled?
  
  # authentication
  acts_as_authentic do |c|
    c.session_class = "CustomerSession".constantize 
    c.validate_password_field       = false
    c.validate_login_field          = false
    c.require_password_confirmation = false
  end
  
  scope :weekly_new,
    where('created_at > ?', 1.week.ago) 

  def phone_filled?
    !phone.blank?
  end

  def pass_filled?
    !password.blank?
  end

  def order_in_cart
    order = self.orders.find_by_state(Order::CART)
    unless order
      order = self.orders.create! :state => Order::CART
    end
    order
  end

  def has_cart?
    !self.orders.find_by_state(Order::CART).nil?
  end

end
