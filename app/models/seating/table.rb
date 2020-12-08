class Seating::Table < ActiveRecord::Base
  attr_accessible :deg, :form, :height, :left_position, :title, :top_position, :width
  belongs_to :plan,  class_name: 'Seating::Plan'
  has_many   :seats, class_name: 'Seating::Seat', dependent: :destroy

  delegate :site, to: :plan
end
