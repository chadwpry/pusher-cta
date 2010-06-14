class Location < ActiveRecord::Base

  # CONSTANTS

  # INCLUDES

  # ASSOCIATIONS
  belongs_to :vehicle_route, :primary_key => :vrid, :foreign_key => :vrid
  belongs_to :pattern,       :primary_key => :pid,  :foreign_key => :pid

  named_scope :active, { :conditions => ["active = ?", true] }

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :vid, :vrid, :pid, :pdistance, :timestamp, :heading, :destination, :lat, :lon
  validates_length_of       :vid,  :maximum => 10
  validates_length_of       :vrid, :maximum => 10
  validates_length_of       :pid,  :maximum => 10

  # INSTANCE METHODS
  def older_than?(time = 15.seconds)
    Time.zone = "Central Time (US & Canada)"
    (Time.zone.now - (Time.zone.parse(timestamp) + time)) < 0
  end

  # CLASS METHODS

end
