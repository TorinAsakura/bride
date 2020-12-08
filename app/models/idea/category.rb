class Idea::Category < ActiveRecord::Base
  attr_accessor :ready, :tag_list
  attr_accessible :name, :height, :width, :tag_ids, :image_attributes, :collection_id,
                  :tag_list, :image, :ready, :description, :common_name, :position
  acts_as_list scope: :collection
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :collection,            class_name: 'Idea::Collection'
  has_and_belongs_to_many :sections, class_name: 'Idea::Section', join_table: 'idea_categories_sections'
  has_many :ideas,                   through: :collection
  has_many :user_ideas,              class_name: 'Idea::UserIdea'
  has_many :category_tasks,          class_name: 'Idea::CategoryTask', dependent: :destroy

  mount_uploader :image, IdeaCategoryUploader

  validates :name, presence: true, uniqueness: true
  scope :ordered,    -> { order('position desc') }
end
