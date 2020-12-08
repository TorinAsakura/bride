# encoding: utf-8
class Task < ActiveRecord::Base
  include TaskModule

  mount_uploader :image, TaskImageUploader

  acts_as_taggable

  has_and_belongs_to_many :plans
  has_many :child_links, class_name: 'TaskDepend', foreign_key: 'parent_id'
  has_many :children, through: :child_links
  has_many :parent_links, class_name: 'TaskDepend', foreign_key: 'task_id'
  has_many :parents, through: :parent_links
  has_many :files, class_name: 'TaskFile', dependent: :destroy

  has_many :firm_catalog_tasks
  has_many :firm_catalogs, through: :firm_catalog_tasks, uniq: true
  has_many :firms, through: :firm_catalogs
  has_many :t_firms, through: :firm_catalogs
  has_many :idea_category_tasks, class_name: 'Idea::CategoryTask'
  has_many :idea_categories, through: :idea_category_tasks, source: :category, uniq: true
  has_many :ideas, through: :idea_categories, order: 'id DESC'
  has_many :images, class_name: 'PostImage', as: :imageable, dependent: :destroy
  has_many :task_positions, dependent: :destroy
  has_many :events

  accepts_nested_attributes_for :firm_catalog_tasks, :idea_category_tasks

  attr_accessor :y, :y2, :x, :x2, :scale
  attr_accessible :description, :name, :tag_list, :cap_firm,
                  :image, :remote_image_url, :y, :y2, :x, :x2, :scale,
                  :firm_catalog_tasks_attributes, :idea_category_tasks_attributes

  before_save do
    if self.simply? || self.advice?
      self.service = nil
    end
    if self.with_service?
      self.idea_categories.destroy_all
      self.firm_catalogs.destroy_all
    end
  end

  def crop?
    x && y && x2 && y2 && scale
  end
end
