class Page < ActiveRecord::Base

  # attributes validation
  validates_presence_of :title, :url

  # behavior of pagination
  cattr_reader :page
  @@per_page = 10
  default_scope :order => 'id DESC'

end
