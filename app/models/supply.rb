class Supply < ActiveRecord::Base

  WAITING  = 1
  PROCESS  = 2
  
  # relations
  belongs_to :supplier
  belongs_to :employee
  has_many :entries

  # attributes validation
  validates_presence_of :sum, :state

  # behavior of pagination
  cattr_reader :per_page
  @@per_page = 5
  default_scope :order => 'id DESC'

  scope :waiting,  
    where(:state => WAITING)

  def save
    self.sum = 0
    self.entries.each do |entry|
      self.sum += entry.product.price
    end
    super
  end

end
