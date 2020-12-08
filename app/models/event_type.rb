# encoding: utf-8
class EventType < ActiveRecord::Base
  has_many :event_categories, :autosave => true

  attr_accessible :name

  validates :name, :presence => true, :length => 3..254

end
