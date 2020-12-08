# encoding: utf-8
class Company < ActiveRecord::Base # Company = одна из возможных форм собственности (ООО, ЗАО, ОАО ...)
  attr_accessible :bank, :bik, :brand, :inn, :ks, :legal_address, :ogrn, :rs

  validates :bank, :bik, :brand, :inn, :ks, :legal_address, :ogrn, :rs, :presence => true

  has_one :firm, :as => :business
end
