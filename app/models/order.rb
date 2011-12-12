# coding: utf-8

class Order < ActiveRecord::Base

  CART      = 0
  WAITING   = 1
  NOT_PAID  = 3
  PAID      = 4
  SENT      = 5
  FINISHED  = 6

  STATES = ['Košík', 'Přijato', 'Nezaplaceno', 'Zaplaceno', 'Odesláno', 'Hotovo']

  # relations
  belongs_to :customer
  accepts_nested_attributes_for :customer

  has_many :items, :include => :product
  has_many :products, :through => :items,
           :select => 'products.*, items.count, items.cost'
  has_many :invoices
  has_one  :invoice_address, :dependent => :destroy
  accepts_nested_attributes_for :invoice_address

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

  scope :not_paid,
    includes(:customer).where(:state => NOT_PAID)

  scope :cart,
    includes(:customer).where(:state => CART)

  scope :paid,
    includes(:customer).where(:state => PAID)

  scope :sent,
    includes(:customer).where(:state => SENT)

  scope :by_state, lambda {|state|
    includes(:customer).where(:state => state) }

  scope :finished_in_month, lambda {|month|
    where("state = #{Order::FINISHED} AND created_at >= :begin AND created_at <= :end", { :begin => month, :end => month.end_of_month })}

  def cart?
    self.state == CART
  end

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

  def remove_all_items
    self.items.delete_all
    self.update_attribute :sum, 0
  end

  def update_item(product, amount)
    item = product.items.in self
    item.count = amount
    item.cost = product.price * amount
    item.save
    actualize_sum
    return item.cost
  end

  def add_item(product, amount=1)
   item = product.items.in self
   if item == nil
     item = self.items.create(
        :count=>amount, :cost=>product.price*amount, :product=>product
     )
   else
     item.count += amount
     item.cost = product.price * item.count
     item.save
   end
   actualize_sum
   return item.cost
  end

  def actualize_sum
    sum = self.items.inject(0) { |sum, i| sum + i.cost }
    self.update_attribute :sum, sum
  end

  def submit(message=nil)
    self.message = message||''
    self.state = WAITING
    self.save
    self.products { |p|
      begin
        p.increment! :counter
        p.decrement! :amount if p.amount > 0
      rescue
        next
      end
     }
    self
  end

  def invoice_address?
    self.invoice_address ? true : false
  end

protected

  def set_defaults
    self.sum = 0 unless self.sum
    self.state = CART unless self.state
  end

end
