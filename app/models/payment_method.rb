class PaymentMethod < ActiveRecord::Base

  has_many :orders

  attr_accessible :name, :cost, :info

  def self.options
    options = []
    PaymentMethod.all.each do |p|
      options << ["#{p.name}, #{p.cost} #{AppConfig.currency}", p.id]
    end
    options
  end

end
