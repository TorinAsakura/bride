# encoding: utf-8
class Pp < ActiveRecord::Base # Pp = Private Person (Частное лицо)
  attr_accessible :middlename, :name, :passport, :passport_date, :passport_issued, :surname

  validates :name, :passport, :passport_issued, :surname, :presence => true

  has_one :firm, :as => :business
end
