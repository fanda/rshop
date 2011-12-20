class Page < ActiveRecord::Base

  before_validation :create_url

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

end
