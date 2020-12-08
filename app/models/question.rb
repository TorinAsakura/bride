# encoding: utf-8
class Question < ActiveRecord::Base
  default_scope order("created_at DESC")
  belongs_to :user
  belongs_to :answer
  belongs_to :question_category
  has_many :answers
  has_many :users, :through => :answers
  attr_accessible :body, :title, :recommended, :question_category_id

  validates :body, :question_category_id, :title, :user_id, :presence => true

  def close?
    !self.answer.nil?
  end

  def recommend!
    self.update_attributes(:recommended => true)
  end

  def unrecommend!
    self.update_attributes(:recommended => false)
  end

end
