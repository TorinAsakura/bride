class Bonus::Reward < ActiveRecord::Base
  belongs_to :payment, polymorphic: true
  belongs_to :referral, class_name: 'User'
  belongs_to :dealer, class_name: 'User'
  attr_accessible :amount_cents, :amount, :dealer, :referral

  monetize :amount_cents, as: :amount

  before_create :add_referral

  scope :recent,        ->(count) { order('`bonus_rewards`.id DESC').limit(count) }
  scope :for_today,     -> { where(["DATE(`bonus_rewards`.created_at) = DATE(?)", Time.zone.now]) }
  scope :for_last_days, ->(days_ago) { where(["DATE(?) <= DATE(`bonus_rewards`.created_at) AND DATE(`bonus_rewards`.created_at) <= DATE(?)", Time.zone.now - (days_ago - 1).days, Time.zone.now]) }
  scope :by_withdrawal, -> { where('`bonus_rewards`.created_at < :now', now: Time.zone.now - 20.days) }

  protected
  def add_referral
    self.referral = self.payment.user
  end
end
