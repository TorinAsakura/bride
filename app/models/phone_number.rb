# encoding: utf-8
class PhoneNumber < ActiveRecord::Base
  belongs_to :address
  attr_accessible :phone
end
