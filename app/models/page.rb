class Page < ActiveRecord::Base

  PROTECTED_PAGES_COUNT = 3

  INDEX_PAGE_TEXT_ID   = 2
  CONTACT_PAGE_TEXT_ID = 3

  before_validation :create_url
  before_destroy :can_be_destroyed?
  #after_save :remove_url, :if => :can_be_destroyed?

  # attributes validation
  validates_presence_of :title, :url

  # behavior of pagination
  #cattr_reader :page
  #@@per_page = 10
  default_scope { order('id DESC') }

  attr_accessible :title, :body

protected

  def create_url
    s = ActiveSupport::Multibyte::Chars.new self.title
    s = s.normalize(:kd).gsub(/[^\x00-\x7F]/,'').gsub(/\s/,'-').downcase
    self.url = s.to_s
  end

  def can_be_destroyed?
    return false if id <= PROTECTED_PAGES_COUNT
  end

  def remove_url
    self.update_column :url, nil
  end

  def self.contact_text
    find CONTACT_PAGE_TEXT_ID
  end

  def self.index_text
    find INDEX_PAGE_TEXT_ID
  end

end
