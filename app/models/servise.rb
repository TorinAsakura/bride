# encoding: utf-8
class Servise < ActiveRecord::Base
  attr_accessible :name
  has_many :tasks
end
