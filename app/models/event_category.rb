# encoding: utf-8
class EventCategory < ActiveRecord::Base
  belongs_to :event_type
  default_scope order(:name)

  attr_accessible :name
  validates :name, :presence => true, :length => 3..254

end
