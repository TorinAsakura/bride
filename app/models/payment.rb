# encoding: utf-8
class Payment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :value, :amount_cents, :amount,
                  :refund_amount_cents, :refund_amount,
                  :currency, :identifier, :payer_id, :state, :token, :type, :terms_of_service, :is_system
  attr_accessor :value, :is_system, :terms_of_service
  monetize :amount_cents, as: :amount
  monetize :refund_amount_cents, as: :refund_amount

  before_validation :convert_value, on: :create

  validates :user_id, presence: { unless: lambda { |payment| payment.is_system } }
  validates :token,      uniqueness: true, allow_nil: true
  validates :identifier, uniqueness: true, allow_nil: true
  validates :amount, numericality: { greater_than_or_equal_to: 100 }
  validates :terms_of_service, acceptance: true

  scope :pending,             -> { where( state: 'pending' )}
  scope :pending_or_canceled, -> { where( state: %w(pending canceled) )}
  scope :completed,           -> { where( state: 'completed' ) }


  state_machine :state, initial: :pending do
    state :pending
    state :canceled
    state :completed
    state :failed

    event :cancel do
      transition pending: :canceled, canceled: :canceled
    end

    event :complete do
      transition pending: :completed, canceled: :completed
    end

    event :failed do
      transition pending: :failed
    end

    after_transition on: :complete do |payment, transition|
      payment.send(:action_after_complete)
    end
  end

  class << self
    def translate_scope
      :"payments.#{self.model_name.i18n_key}"
    end
  end

  def payment_system_name
    self.type.split(/::/).last.sub('Deposit', '')
  end

  def payment_name
    self.class.to_s.underscore.tr('/','_')
  end

  def terms_of_service
    @terms_of_service
  end

  def is_system
    @is_system || respond_to?(:purse_payment_system_withdrawal) && self.purse_payment_system_withdrawal.present?
  end

  protected

  def convert_value
    if value
      begin
        self.amount = Kernel.Integer(value)/self.user.purse.deposit_course.to_f
      rescue ArgumentError, TypeError
        errors.add(:amount, :not_a_integer)
      end
    end
  end
end
