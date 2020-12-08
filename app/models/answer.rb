# encoding: utf-8
class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  attr_accessible :body

  acts_as_voteable
end
