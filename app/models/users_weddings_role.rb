# encoding: utf-8
class UsersWeddingsRole < ActiveRecord::Base
  belongs_to :client
  has_one :user, through: :client #just for user remove_role works fine
  belongs_to :wedding
  belongs_to :role

  attr_accessible :client_id, :wedding_id, :role_id
end
