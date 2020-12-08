class PursePayment < ActiveRecord::Base
  SUBCLASSES = %w(
    PursePayment::AdminDeposit PursePayment::PurseDeposit PursePayment::SystemAdminDeposit PursePayment::TransferToSystem
    PursePayment::Subscription PursePayment::SystemSubscription PursePayment::DealerSubscription PursePayment::DealerTransferSubscription
    PursePayment::PayCertificate PursePayment::Certificate PursePayment::CertificateTransfer PursePayment::CertificateSubscription
    PursePayment::SystemCertificateSubscription PursePayment::SystemDepositFee PursePayment::SystemTransferFromFirm
    PursePayment::TransferSubscription
  )

  paginates_per 20

  belongs_to :source_purse, class_name: 'Purse'
  belongs_to :purse
  belongs_to :source_payment
  belongs_to :target, polymorphic: true

  monetize :amount_cents, as: :amount, allow_nil: false, numericality: true

  attr_accessible :amount_cents, :purse, :purse_id, :source_purse, :source_purse_id, :amount, :description,
                  :name, :params, :state, :type, :source_payment, :source_payment_id

  delegate :user, to: :purse

  serialize :params

  before_create :add_purse_to_system_payment, if: :system_purse_blank?
  after_create :add_details #before dont have id

  scope :blocked,    -> { where(type: self.blocked_types) }
  scope :pending,    -> { where(state: 'pending'  ) }
  scope :canceled,   -> { where(state: 'canceled' ) }
  scope :completed,  -> { where(state: 'completed') }
  scope :systemic,   -> { where(type: PursePayment.system_types) }
  scope :ordered,    -> { order('id desc') }
  scope :deposit,    -> { where('amount_cents > 0') }
  scope :withdrawal, -> { where('amount_cents < 0') }

  state_machine :state, initial: :pending do
    state :pending
    state :canceled
    state :completed
    state :failed

    event :cancel do
      transition pending: :canceled, canceled: :canceled
    end

    event :complete do
      transition pending: :completed
    end

    event :failed do
      transition pending: :failed
    end

    after_transition on: :complete do |payment, transition|
      payment.target_type.constantize.unscoped do
        payment.send(:action_after_complete)
      end
    end
  end

  class << self
    def to_name
      I18n.t('type', scope: translate_scope)
    end

    def translate_scope
      :"purse_payments.#{self.model_name.i18n_key}"
    end

    def system?
      false
    end

    def blocked?
      false
    end

    def in_filter?
      false
    end

    def system_amount
      SystemAccount.svadba.purse.amount
    end

    def all_types
      self::SUBCLASSES.sort
    end

    def system_types
      self.all_types.select{|type| type.constantize.system?}
    end

    def filter_types
      self.all_types.select{|type| type.constantize.in_filter?}
    end

    def types
      self.all_types.select{|type| !type.constantize.system?}
    end

    def user_types
      self.types.select{|type| type.constantize.for_user?}
    end

    def blocked_types
      self.types.select{|type| type.constantize.blocked?}
    end

    def type_to_subclass(type)
      self.all_types.select{|t| t.match('::'+type.classify)}.first
    end
  end

  def payment_name
    self.class.to_s.underscore.tr('/','_')
  end

  def system_purse_blank?
    self.purse.blank? && self.class.system?
  end

  def source_payment
    source_payment_id = self.params.present? && self.params[:source_payment_id]
    source_payment_id.present? ? PursePayment.find_all_by_id(source_payment_id.to_i) : nil
  end

  protected
  def add_purse_to_system_payment
    self.purse = SystemAccount.svadba.purse
  end

  def action_after_complete
    self.purse.change!(self.amount)
  end

  def add_details
    nil
  end

  def add_subscription_reward!
    subscription = self.source_payment.try(:subscription)
    dealer_firm = subscription.try(:dealer)
    if dealer_firm && self.source_payment.bonus_reward.blank?
      dealer = dealer_firm.user
      city = subscription.service.is_a?(Bonus::Service::AddCity) ? subscription.signing_object : subscription.target.base_city
      percent = dealer_firm.dealer_percent(city)
      amount = self.amount*percent.to_i/100
      self.source_payment.build_bonus_reward(amount: amount, dealer: dealer).save! unless amount.to_f.zero?
    end
  end
end
