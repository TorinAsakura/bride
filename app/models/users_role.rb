# encoding: utf-8
require 'composite_primary_keys'

class UsersRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
  self.primary_keys= [:role_id,:user_id]
end
