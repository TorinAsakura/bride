class Bonus::SigningService < ActiveRecord::Base
  belongs_to :service
  belongs_to :target, polymorphic: true  # Firm|Client
  has_many :subscriptions, class_name: 'Bonus::Subscription'
  attr_accessible :ends_at, :loyalty_at, :starts_at

  validates :service_id, presence: true

  delegate :pay_once?, to: :service

  before_create :add_start_at

  def active?
    self.pay_once? || (ends_at.present? && ends_at > Date.today)
  end

  def select_loyalty
    loyalty_years = Date.today.year - self.loyalty_at.year
    loyalty = self.service.loyalties.where('years_count <= ?', loyalty_years).ordered.last
    loyalty.try(:coefficient) || 1
  end

  protected
  def add_time!(month_count = 1)
    self.ends_at = (self.active? ? self.ends_at : Time.zone.now) + month_count.to_i.months
    self.add_loyalty_at_and_target_member!
  end

  def add_trial!
    if self.new_record?
      self.ends_at = Time.zone.now + self.service.trial_duration.days
      self.add_loyalty_at_and_target_member!
    end
  end

  def add_loyalty_at_and_target_member!
    self.loyalty_at = Time.zone.now unless self.active? && self.loyalty_at.present?
    self.target.update_attribute(self.service.member_method, self.pay_once? ? Time.zone.now : self.ends_at) if self.target.is_a?(Firm) && !self.service.uniq_form?
    self.save!
  end

  def add_start_at
    self.starts_at = Time.zone.now
  end
end
