# encoding: utf-8
class Page < ActiveRecord::Base
  DEPTH = 2
  attr_accessible :name, :title, :content, :main, :active, :hidden, :site_attributes
  validates :name, :title, presence: true

  belongs_to :site
  after_save :reset_main
  accepts_nested_attributes_for :site

  has_many :comments, as: :commentable

  scope :ordered, -> { order('id asc') }

  def reset_main
    self.site.pages.where('id != ?', self.id).update_all(main: false) if self.main
  end

  def root_object
    self
  end
end
