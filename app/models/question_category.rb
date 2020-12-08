# encoding: utf-8
class QuestionCategory < ActiveRecord::Base
  attr_accessible :name, :community_id
  belongs_to :community
  has_many :questions
end
