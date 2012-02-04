require "open-uri"

class Product < ActiveRecord::Base
  extend FriendlyId

  ACTIVE     = 1
  NOT_ACTIVE = 0

  acts_as_list

  # relations
  belongs_to :category
  belongs_to :supplier

  has_many :orders, :through => :items
  has_many :items do
    def in(order)
      item = find_by_order_id order.id
    end
  end
  accepts_nested_attributes_for :items

  has_many :supplies, :through => :entries

  friendly_id :title, :use => :slugged #, :approximate_ascii => true

  # picture
  has_attached_file :picture,
  :url => "/pictures/:id/:style_:basename.:extension",
  :path => ":rails_root/public/pictures/:id/:style_:basename.:extension",
  :default_url => "/pictures/:style_default.png",
  :default_style => :large,
  :web_root => '/pictures/', :storage => :filesystem,
                           :styles => { :square   => "150x150#",
                                        :large    => "400x400>",
                                        :original => "840x840>"}
  attr_protected :picture_file_name,
                 :picture_content_type,
                 :picture_size,
                 :picture_updated_at
  attr_accessor  :picture_url
  alias_attribute :name, :title
  # attributes validation
  validates_presence_of :title, :price, :amount
  validates_numericality_of :price,  :greater_than_or_equal_to => 0
  #validates_numericality_of :amount, :greater_than_or_equal_to => 0

  validates_attachment_content_type :picture, :unless => :before_new,
  :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg',  'image/png']

  # behavior of pagination
  cattr_reader :per_page
  @@per_page = 10
  default_scope :order => 'position ASC'

  scope :active,
    includes(:category).where(:active => 1)

  scope :inactive,
    includes(:category).where(:active => 0)

  scope :newest,
    active.order('id DESC')

  scope :related,
    active.order("RAND()").limit(4)

  scope :without_category,
    where(:category_id => nil)


  def self.all_active_in(category=nil)
    return scoped unless category
    select("distinct(products.id), products.*").
    joins(:category).where(:active => 1).
    where(["categories.lft BETWEEN ? AND ?", category.lft, category.rgt])
  end

  def before_new; true; end

  def available?
    self.amount != 0 ? true : false
  end

  def full_description
    self.description.html_safe # TODO
  end

  def picture_from_url(url)
    self.picture = open(url)
  end

  def active?
    self.active == ACTIVE
  end

  def make_active!
    self.update_attribute :active, true
  end

end
