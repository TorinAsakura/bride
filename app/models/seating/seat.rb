class Seating::Seat < ActiveRecord::Base
  belongs_to :table
  belongs_to :guest, polymorphic: true
  attr_accessible :gender, :side, :position, :guest
  acts_as_list scope: :table
  delegate :site, to: :table
end
