# encoding: utf-8
class Country < ActiveRecord::Base
  attr_accessible :name, :code, :iso_numeric
  has_many :regions
  has_many :cities, through: :regions
  has_many :clients

  validates :name, presence: true
end
