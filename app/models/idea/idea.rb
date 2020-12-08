class Idea::Idea < ActiveRecord::Base
  extend ModelExt::Paginates

  paginates_per 30
  DEPTH = 2

  has_one :image, class_name: 'Idea::Image', as: :imageable, dependent: :destroy
  has_many :user_ideas, class_name: 'Idea::UserIdea', dependent: :destroy
  belongs_to :collection, class_name: 'Idea::Collection'
  has_many :categories, through: :collection

  acts_as_taggable
  acts_as_taggable_on :colors
  acts_as_votable
  acts_as_commentable

  attr_accessible :description, :image_attributes, :tag_list, :name, :color_ids

  accepts_nested_attributes_for :image

  validates :image, presence: true

  scope :ordered,     -> {order('idea_ideas.id desc')}
  scope :next,        ->(id){ where('idea_ideas.id < ?', id) }
  scope :prev,        ->(id){ where('idea_ideas.id > ?', id) }
  scope :category,    ->(category){ joins(:categories).where(idea_categories: {id: category.id})}

  def root_object
    self
  end

  def next_idea(category = nil, site = nil)
    ideas = site ? site.ideas : Idea::Idea
    ideas = ideas.category(category).uniq if category.present?
    ideas = ideas.ordered
    ideas.next(id).first || ideas.first
  end

  def prev_idea(category = nil, site = nil)
    ideas = site ? site.ideas : Idea::Idea
    ideas = ideas.category(category) if category.present?
    ideas = ideas.uniq.ordered
    ideas.prev(id).last || ideas.last
  end

  # TODO refactor me (add indices etc)
  def self.search(query)
    self.where(self.arel_table[:name].matches("%#{query}%").or(self.arel_table[:description].matches("%#{query}%")))
  end
end
