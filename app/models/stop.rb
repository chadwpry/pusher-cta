class Stop < ActiveRecord::Base

  # CONSTANTS

  # INCLUDES

  # ASSOCIATIONS

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :stid, :vrid, :direction, :name, :lat, :lon
  validates_length_of       :stid, :maximum => 10
  validates_length_of       :vrid, :maximum => 10
  validates_uniqueness_of   :stid

  # INSTANCE METHODS

  # CLASS METHODS

end
