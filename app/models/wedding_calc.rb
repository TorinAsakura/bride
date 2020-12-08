# encoding: utf-8
class WeddingCalc < ActiveRecord::Base
  attr_accessible :categories, :site_id

  belongs_to :site
  belongs_to :wedding
end
