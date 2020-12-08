# encoding: utf-8
class Complaint < ActiveRecord::Base
  belongs_to :user, with_deleted: true
  belongs_to :pretension, :polymorphic => true
  validates :user_id, :uniqueness => {:scope => [:pretension_id, :pretension_type]}
  validates :user, :pretension, :content, :presence => :true

  attr_accessible :content

  paginates_per 15
end
