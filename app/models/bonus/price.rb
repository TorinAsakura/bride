class Bonus::Price < ActiveRecord::Base
  belongs_to :service
  belongs_to :firm_catalog
  attr_accessible :amount_cents, :amount

  monetize :amount_cents, as: :amount, allow_nil: false, numericality: { greater_than_or_equal_to: 10, less_than_or_equal_to: :max_amount }

  def max_amount
    self.service.amount.to_f*10
  end
end
