class Idea::CategoryTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :category, class_name: 'Idea::Category'
  belongs_to :section,  class_name: 'Idea::Section'

  attr_accessible :category_id, :task_id, :section_id

  before_create :set_section

  private
  def set_section
    self.section = self.category.sections.first
  end
end
