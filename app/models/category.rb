class Category < ActiveRecord::Base
  extend FriendlyId

  acts_as_nested_set

  # relations
  has_many :products

  friendly_id :title, :use => :slugged #, :approximate_ascii => true

  # attributes validation
  validates_presence_of :title

  # behavior of pagination
  cattr_reader :per_page
  @@per_page = 10
  default_scope :order => 'position ASC'
  default_scope :include => :children

end
