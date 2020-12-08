class SystemAccount < ActiveRecord::Base
  belongs_to :purse
  attr_accessible :identifier, :name

  delegate :amount, to: :purse

  ## Callbacks
  before_create :create_purse

  class << self
    def total_amount
      self.all.sum(&:amount)
    end

    def svadba
      self.find_by_identifier('svadba')
    end
  end

  protected
  def create_purse
    self.purse = Purse.create!(amount:0) if self.purse.blank?
  end
end
