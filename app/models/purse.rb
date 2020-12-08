class Purse < ActiveRecord::Base
  DEALER_COURSE = 4
  monetize :amount_cents, as: :amount
  ## Relationships
  has_one :user
  has_one :system_account
  has_many :purse_payments

  ## Accessible attributes
  attr_accessible :amount_cents, :amount, :deposit_course

  def system?
    self.system_account.present?
  end

  def blocked_amount
    self.purse_payments.blocked.pending.map(&:amount).sum.to_money
  end

  def available_amount
    self.amount + self.blocked_amount
  end

  def change!(amount)
    self.amount += amount
    self.save!
  end

  private
  def discount_by_dealer!
    self.update_attribute(:deposit_course, DEALER_COURSE)
  end

  def discount_by_firm!
    self.update_attribute(:deposit_course, 1)
  end
end
