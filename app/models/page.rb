class Page < ActiveRecord::Base

  PROTECTED_PAGES_COUNT = 2

  INDEX_PAGE_TEXT_ID   = 1
  CONTACT_PAGE_TEXT_ID = 2

  before_validation :create_url
  before_destroy :can_be_destroyed?
  after_save :remove_url, :if => 'id <= PROTECTED_PAGES_COUNT'

  # attributes validation
  validates_presence_of :title, :url

  # behavior of pagination
  #cattr_reader :page
  #@@per_page = 10
  default_scope :order => 'id DESC'

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

end
