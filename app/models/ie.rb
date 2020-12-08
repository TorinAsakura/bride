# encoding: utf-8
class Ie < ActiveRecord::Base # Ie = individual entrepreneur (индивидуальный предприниматель)
  attr_accessible :bank, :bik, :brand, :inn, :ks, :legal_address, :ogrnip, :rs

  validates :brand, :inn, :legal_address, :ogrnip, :presence => true

  has_one :firm, :as => :business
end
