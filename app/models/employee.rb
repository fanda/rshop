class Employee < ActiveRecord::Base
 
  # relations
  has_many :notes
  has_many :orders
  has_many :supplies

  # attributes validation
  validates_presence_of :login,:email
  validates_uniqueness_of :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :phone, :with => /^[+0-9 ]{5,20}$/i, :if => :phone_filled?
  validates_format_of :login, :with => /^\w+$/i
  validates_length_of :login, :within => 3..40

  # authentication 
  acts_as_authentic do |c|
    c.session_class = "EmployeeSession".constantize 
  end 

  def phone_filled?
    !phone.blank?
  end
end
