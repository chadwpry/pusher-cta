class Point < ActiveRecord::Base

  # CONSTANTS

  # INCLUDES

  # ASSOCIATIONS
  belongs_to :pattern, :primary_key => :pid, :foreign_key => :pid

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :pid, :sequence, :lat, :lon, :pttype
  validates_length_of       :pid,  :maximum => 10
  validates_length_of       :pttype,  :maximum => 1
  validates_uniqueness_of   :pid, :scope => :sequence
  validates_numericality_of :sequence
  validates_length_of       :stid, :maximum => 10, :allow_nil => true
#  validates_numericality_of :distance

  # INSTANCE METHODS

  # CLASS METHODS

end
