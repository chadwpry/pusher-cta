class Vehicle < ActiveRecord::Base

  # CONSTANTS

  # INCLUDES

  # ASSOCIATIONS

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :vid, :vrid
  validates_length_of       :vid,  :maximum => 10
  validates_length_of       :vrid, :maximum => 10
  validates_uniqueness_of   :vid

  # INSTANCE METHODS

  # CLASS METHODS

end
