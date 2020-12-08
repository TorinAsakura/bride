# encoding: utf-8
class Programm < ActiveRecord::Base
  default_scope order('programms.time ASC')

  attr_accessible :description, :name, :time, :client_id, :side_id, :second_day
  belongs_to :client
  belongs_to :site

  scope :wedding_day, -> {where(:second_day => false)}
  scope :second_day, -> {where(:second_day => true)}

  validates :name, :time, :client, :site, presence: true
end
