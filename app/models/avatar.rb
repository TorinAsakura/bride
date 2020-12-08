# encoding: utf-8
class Avatar < ActiveRecord::Base
  DEPTH = 2

  belongs_to :client
  acts_as_commentable

  def root_object
    client.try(:root_object)
  end
end
