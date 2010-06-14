class Pattern < ActiveRecord::Base

  # CONSTANTS

  # INCLUDES

  # ASSOCIATIONS
  set_primary_key "pid"
  has_many :points,    :foreign_key => :pid, :dependent => :destroy
  has_many :locations, :foreign_key => :pid
  belongs_to :vehicle_route, :foreign_key => :vrid

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :pid, :vrid, :length, :direction
  validates_length_of       :pid,  :maximum => 10
  validates_length_of       :vrid, :maximum => 10
  validates_numericality_of :length

  # INSTANCE METHODS

  # CLASS METHODS

end
