# encoding: utf-8
class Region < ActiveRecord::Base
  belongs_to :country
  has_many :cities
  attr_accessible :name, :country_id

  validates :name, :country, :presence => true
end
