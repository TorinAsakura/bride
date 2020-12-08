# encoding: utf-8
class Icon < ActiveRecord::Base
  attr_accessible :image, :name
  mount_uploader :image, IconUploader
end
