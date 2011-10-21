# coding: utf-8

class Order < ActiveRecord::Base

  CART      = 0
  WAITING   = 1
  CALLED    = 2
  NOT_PAID  = 3
  PAID      = 4
  SENT      = 5
  FINISHED  = 6

  STATES = ['Košík', 'Přijato', 'Kontaktováno', 'Nezaplaceno', 'Zaplaceno', 'Odesláno', 'Hotovo']

  # relations
  belongs_to :customer
  belongs_to :employee
  has_many :items, :include => :product
  has_many :invoices
  has_one  :invoice_address, :dependent => :destroy
  # attributes validation
  validates_presence_of :sum, :state

  before_validation :set_defaults

  # behavior of pagination
  cattr_reader :order_page
  @@per_page = 5
  default_scope :order => 'id DESC'

  scope :finished_by, lambda {|cid|
    includes(:employee).where(:state => FINISHED, :customer_id => cid) }

  scope :waiting,
    includes(:customer).where("state != #{FINISHED} AND state != #{CART}")

  scope :finished,
    includes(:customer).where(:state => FINISHED)

  scope :by_state, lambda {|state|
    includes(:customer).where(:state => state) }

  scope :finished_in_month, lambda {|month|
    where("state = #{Order::FINISHED} AND created_at >= :begin AND created_at <= :end",
          { :begin => month, :end => month.end_of_month })}


  def self.state_options
    options = []
    STATES.each_with_index { |s,i| options << [s, i] if i >0 }
    options
  end

  def self.monthly_products(month)
    orders = Order.finished_in_month month
    all_items = orders.collect{|o|
      o.items
    }
    products = all_items.flatten.inject(Hash.new(0)){ |h,item|
      h[item.product] += item.amount; h 
    }
    products.sort_by{|k,v|-v }
  end

  def state_in_words
    STATES[self.state]
  end

  def products
    self.items.collect { |i| i.product }
  end

  def remove_all
    self.items.delete_all
    self.update_attribute :sum, 0
  end

  def update_item(product, amount)
    item = product.items.in self
    item.amount = amount
    item.price = product.price * amount
    item.save
    actualize_sum
    return item.price
  end

  def add_item(product, amount=1)
   item = product.items.in self
   if item == nil
     item = self.items.create(:amount=>amount, :price=>product.price*amount, :product=>product)
   else
     item.amount += amount
     item.price = product.price * item.amount
     item.save
   end
   actualize_sum
   return item.price
  end

  def actualize_sum
    sum = self.items.inject(0) { |sum, i| sum + i.price }
    self.update_attribute :sum, sum
  end

  def submit(message)
    self.message = message||''
    self.state = WAITING
    self.save
    self.items.each { |i|
      begin
        i.product.increment! :counter
        i.product.decrement! :amount if p.amount > 0
      rescue
      next; end
     }
    self
  end

protected

  def set_defaults
    self.sum = 0 unless self.sum
    self.state = CART unless self.state
  end

end
