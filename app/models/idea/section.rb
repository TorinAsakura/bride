class Idea::Section < ActiveRecord::Base
  attr_accessible :name, :image, :description, :position
  acts_as_list
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true

  mount_uploader :image, IdeaSectionUploader

  has_and_belongs_to_many :categories, class_name: 'Idea::Category', join_table: 'idea_categories_sections'
  has_many :category_tasks,            class_name: 'Idea::CategoryTask', dependent: :destroy

  scope :ordered,    -> { order('position desc') }
end
