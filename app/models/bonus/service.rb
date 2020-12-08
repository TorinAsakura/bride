class Bonus::Service < ActiveRecord::Base
  attr_accessible :amount_cents, :amount, :dealer_percent, :description, :discount, :identifier, :list,
                  :name, :pay_once, :position, :slug, :state, :trial_duration, :type

  extend FriendlyId
  friendly_id :identifier, use: :slugged

  acts_as_paranoid
  acts_as_list

  has_many :certificates, class_name: 'Bonus::Certificate'

  # Monetization
  monetize :amount_cents, as: :amount

  # Validations
  validates :name, :description, :identifier, presence: true
  validates :name, :identifier, uniqueness: true
  validates :amount, numericality: true
  validates :dealer_percent, :discount, :trial_duration, numericality: true

  # Scopes
  scope :active,     -> { where(state: 'active') }
  scope :ordered,    -> { order('position asc') }
  scope :with_trial, -> { where('trial_duration > 0')}
  scope :public,     -> { active.list.ordered }
  scope :list,       -> { where(list: true)}

  # State machine
  state_machine :state, initial: :active do
    state :active
    state :disabled

    event :disable do
      transition active: :disabled
    end

    event :activate do
      transition disabled: :active
    end
  end

  def pro?
    false
  end

  def uniq_form?
    false
  end

  def has_subscriptions?
    false
  end

  def trial?
    trial_duration > 0
  end

  def price(firm, item=nil)
    self.nice_amount
  end

  def nice_amount
    self.amount.to_nice
  end

  def member_method
    "bonus_#{self.identifier.underscore}_at"
  end

  def icon
    case self.identifier
      when 'vip'
        'icon-shield'
      when 'color'
        'icon-star'
      else
        'icon-star-empty'
      end
  end
end
