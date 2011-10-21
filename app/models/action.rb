class Action < ActiveRecord::Base

  FRESHNESS = 15 # minutes

  MAX_ATTEMPTS = 5   

  def self.control_record(ctrl)
    r = where(
      "created_at >= ? AND control = ?", Time.now - FRESHNESS.minutes, ctrl
    ).first
    r = self.create!(:control => ctrl) unless r
    r
  end

  def can_check_pin?
    self.counter < 5
  end

  def increment_counter
    self.increment! :counter
  end

end
