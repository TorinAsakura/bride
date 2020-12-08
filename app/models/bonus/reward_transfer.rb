class Bonus::RewardTransfer < ActiveRecord::Base
  belongs_to :dealer, class_name: 'User'
  belongs_to :payer, class_name: 'User'
  attr_accessible :amount_cents, :amount

  monetize :amount_cents, as: :amount, allow_nil: false, numericality: true

  validate :is_valid_reward_amount?, on: :create

  protected
  def is_valid_reward_amount?
    errors.add(:amount, :value_is_very_large) if self.amount.to_f > self.dealer.outstanding_amount_on_reward.to_f
  end
end
