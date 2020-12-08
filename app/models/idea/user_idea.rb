class Idea::UserIdea < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea, class_name: 'Idea::Idea'
  belongs_to :category, class_name: 'Idea::Category'

  attr_accessible :starred, :user_id, :category_id, :idea_id, :cover

  scope :cover, -> {where(cover: true)}

  def trigger_cover
    if self.cover
      self.update_attributes(cover: false)
    else
      old_cover = self.user.user_ideas.category(self.category_id).cover.first
      old_cover.update_attributes(cover: false) if old_cover
      self.update_attributes(cover: true)
    end
  end
end
