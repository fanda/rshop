class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :name, :surname, :street, :place, :post_code, :phone

  # relations
  has_many :orders

  # attributes validation
  validates_presence_of :email, :name, :surname, :street, :place, :post_code
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /\A(|([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))\Z/i
  validates_format_of :post_code, :with => /\A(|(\d{3,3}\s?\d{2,2}))\Z/i
  validates_format_of :phone, :with => /\A[+0-9 ]{5,20}\Z/i, :if => :phone_filled?

  def self.weekly_new
    where('created_at > ?', 1.week.ago)
  end

  def fullname
    "#{self.name} #{self.surname}"
  end

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
