# encoding: utf-8
class Promise < ActiveRecord::Base
  belongs_to :wishlist
  belongs_to :client
  attr_accessible :description
end
