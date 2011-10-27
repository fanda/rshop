class Supply < ActiveRecord::Base

  WAITING     = 1
  IN_PROCESS  = 2
  FINISHED    = 3

  # relations
  belongs_to :supplier
  belongs_to :admin_user
  has_many :products, :through => :entries,
           :select => 'products.*, entries.quantity'

  # attributes validation
  validates_presence_of :sum, :state

  # behavior of pagination
  cattr_reader :per_page
  @@per_page = 5
  default_scope :order => 'id DESC'

  scope :waiting,
    where(:state => WAITING)

  def save
    self.sum = self.products.inject(0) {|sum,p| sum + p.price * p.quantity}
    super
  end

end
