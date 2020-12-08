class Bonus::Subscription < ActiveRecord::Base
  belongs_to :service                             #Услуга
  belongs_to :user                                #Кому подключается
  belongs_to :payer,  polymorphic: true           #Кто подключил(Фирма, диллер или бонус от системы)
  belongs_to :target, polymorphic: true           #Цель услуги(Обьект назначения) - Фирма или Клиент Firm|Client
  belongs_to :signing_service                     #Подключенная услуга клиента
  belongs_to :payment, polymorphic: true          #Платеж
  belongs_to :package                             #Пакет для оплаты
  belongs_to :signing_object, polymorphic: true   #Обьект оплаты City|FirmCatalog
  belongs_to :certificate, class_name: 'Bonus::Certificate' # Подарочный сертификат
  attr_accessible :amount, :ends_at, :pay_once, :starts_at, :state, :payment_id, :payment_type,
                  :package_id, :signing_object_id, :signing_object_type, :payer, :service, :signing_service, :certificate

  attr_accessor :parent_catalog_id
  attr_accessible :parent_catalog_id

  validates :user_id, :service_id, :payer_id, presence: true

  # Monetization
  monetize :amount_cents, as: :amount

  # Scopes
  scope :pending,            -> { where(state: 'pending') }
  scope :active,             -> { where(state: 'active') }
  scope :required_to_expire, -> { active.where('ends_at IS NOT NULL AND ends_at > now()') }
  scope :signing_object,     ->(signing_object) { where(signing_object_id: signing_object.id, signing_object_type: signing_object.class.to_s) }

  # Callbacks
  before_validation :copy_defaults, on: :create
  after_create :payment_and_activate!

  validate :has_amount_in_purse?, on: :create

  # State machine
  state_machine :state, initial: :pending do
    state :pending
    state :active
    state :expired

    event :activate do
      transition pending: :active
    end

    event :expire do
      transition active: :expired
    end

    after_transition on: :activate do |subscription, transition|
      subscription.send(:after_activate!)
    end
  end

  def charged?
    payment.present?
  end

  def paid?
    amount_cents > 0
  end

  def required_to_expire?
    ends_at && Time.zone.now > ends_at.to_time
  end

  def gift?
    !self.payer.eql?(self.user)
  end

  def dealer
    self.service.is_a?(Bonus::Service::AddCity) ? self.target.city_firms.by_city(self.signing_object).first.try(:dealer) : self.target.dealer
  end

  def signing_objects
    self.target.send(signing_object_type.underscore.pluralize)
  end

  def all_signing_objects
    self.target.send("all_#{signing_object_type.underscore.pluralize}")
  end

  def all_signing_object_ids
    all_signing_objects.map(&:id)
  end

  def signing_base_objects
    signing_base = service.signing_base_class_name.underscore.pluralize
    by_self = 'by_'+service.signing_object_name.underscore
    self.target.send(signing_base).send(by_self, signing_object)
  end

  def deleted_signing_object
    if service.present? && service.uniq_form?
      signing_base_objects.only_deleted.first
    end
  end

  protected
  def copy_defaults
    if (service = self.service).present?
      signing_service = self.target.bonus_signing_services.service(service).first
      self.signing_service = signing_service if self.signing_service.blank?
      self.user = self.target.user
      self.starts_at = signing_service.try(:ends_at) || Time.zone.now if self.starts_at.blank?
      self.ends_at = self.starts_at + (self.package.try(:months_count) || 1).months unless self.ends_at || self.service.uniq_form?
    end
  end

  def has_amount_in_purse?
    if self.paid? && self.amount > self.payer.purse.available_amount
      if self.service.pro?
        self.errors.add(:base, :no_amount_in_your_purse_pro)
      else
        self.errors.add(:base, :no_amount_in_your_purse)
      end
    end
  end

  def payment_and_activate!
    if self.paid?
      payment = if self.gift?
                  if self.certificate.present?
                    self.target.purse_payment_certificate_subscriptions.build(purse: self.target.purse, amount: -self.amount, source_payment: self.certificate.payment.certificate_payments.by_target(self.target).first.certificate_transfer_payment)
                  else
                    self.target.purse_payment_dealer_subscriptions.build(purse: self.payer.purse, amount: -self.amount)
                  end
                else
                  self.target.purse_payment_subscriptions.build(purse: self.target.purse, amount: -self.amount)
                end
      payment.subscription = self
      if payment.save
        self.payment = payment
        payment.complete!
      end
    end
    self.activate!
  end

  def after_activate!
    if (signing_service = self.signing_service).blank?
      signing_service = self.target.bonus_signing_services.service(self.service).create(starts_at: self.starts_at, ends_at: self.ends_at)
      self.update_attribute(:signing_service_id, signing_service.id)
      signing_service.send(:add_loyalty_at_and_target_member!)
    else
      signing_service.send(:add_time!, self.package.try(:months_count) || 1)
    end

    self.push_signing_object!

    if self.gift?
      if target.is_a?(Firm) && self.payer.is_a?(User)
        dealer = self.payer.firm
        if target.dealer.blank?
          target.dealer = dealer
          target.save
        end

        if (city_firm = target.city_firms.by_city(dealer.base_city).first).present? && city_firm.dealer.blank?
          city_firm.dealer = dealer
          city_firm.save
        end
      end
    end
  end

  def push_signing_object!
    if signing_object.present?
      if (deleted_signing_object = self.deleted_signing_object).present?
        deleted_signing_object.send(:paranoid_recover!)
      else
        signing_objects.push(signing_object) rescue true
      end
    end
  end
end
