class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  validates_format_of :phone, :with => /\A[+0-9 ]{5,20}\Z/i, :if => :phone_filled?

  has_many :supplies

  def phone_filled?
    !phone.blank?
  end

end
