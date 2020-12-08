class Seating::Plan < ActiveRecord::Base
  belongs_to :site
  has_many :tables, class_name: 'Seating::Table', dependent: :destroy

end
