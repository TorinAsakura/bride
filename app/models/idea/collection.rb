class Idea::Collection < ActiveRecord::Base
  HOMEPAGE_COLLECTIONS = [6, 7, 13, 19, 25, 28, 27, 29]

  attr_accessible :name, :ideas_attributes
  has_many :categories,  class_name: 'Idea::Category'
  has_many :ideas,       class_name: 'Idea::Idea'
  accepts_nested_attributes_for :ideas, allow_destroy: true

  def self.homepage_ideas
    includes(:ideas, :categories).where(id: HOMEPAGE_COLLECTIONS).all.map do |collection|
      {
          category: collection.categories.first,
          idea: collection.ideas.reorder('RANDOM()').first
      }
    end
  end
end
