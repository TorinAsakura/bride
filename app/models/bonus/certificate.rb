class Bonus::Certificate < ActiveRecord::Base
  attr_accessible :owner, :payment, :number, :service_id, :name, :description, :ends_at, :starts_at, :amount, :amount_cents,
                  :quantity, :limit, :used_quantity
  attr_accessor :firm
  attr_accessible :firm

  acts_as_paranoid

  belongs_to :owner,   polymorphic: true # Owner - Dealer User | SystemAccount
  belongs_to :payment, class_name: 'PursePayment::PayCertificate', autosave: true
  belongs_to :service

  # Monetization
  monetize :amount_cents, as: :amount

  validates :name, :owner_id, presence: true
  validates :number, uniqueness: true, allow_nil: true
  validates :amount, numericality: { greater_than_or_equal_to: 100 }, if: :no_service?
  validates :quantity, :limit, numericality: { greater_than_or_equal_to: 1 }
  validate  :has_amount_in_purse
  validate  :complete_by_firm, if: lambda { |c| c.firm.present? }

  before_create :generate_number
  before_create :valid_quantity
  after_create :add_payment
  before_validation :add_system_account
  around_update :update_payment_if_payment_changed

  scope :number, ->(number) {active.where(number: number)}
  scope :active, -> { where('starts_at < now() AND ends_at > now()') }

  delegate :purse, to: :owner

  def complete!
    payment = self.firm.purse_payment_certificates.build(amount: -self.bonus_amount, purse: self.purse, source_payment: self.payment)
    if payment.save && payment.complete!
      self.increment!(:used_quantity)
      self.send(:update_payment_amount!)
    end
  end

  def cancel!
    self.update_attribute(:quantity, self.used_quantity)
    self.payment.cancel!
  end

  def available_quantity
    self.quantity - self.used_quantity
  end

  def used?
    !self.used_quantity.zero?
  end

  def bonus_amount
    (service = self.service).present? ? service.nice_amount : self.amount
  end

  def no_service?
    self.service_id.blank?
  end

  protected
  def generate_number
    begin
      number = SecureRandom.base64(16).gsub("/","").gsub(/\W/,"").upcase[0..19].split('').in_groups_of(4).map(&:join).join('-')
    end while ::Bonus::Certificate.find_all_by_number(number).nil?
    self.number = number if self.number.blank?
  end

  def add_system_account
    self.owner = SystemAccount.svadba if self.owner.blank?
  end

  def valid_quantity
    if bonus_amount > 0
      available_amount = purse.available_amount
      max_quantity = (available_amount/bonus_amount).to_i
      self.quantity = max_quantity if self.quantity > max_quantity
    end
  end

  def add_payment
    self.build_payment(amount: -self.bonus_amount*quantity, purse: self.purse, certificate: self).save
  end

  def update_payment_amount!
    self.payment.update_attribute(:amount, self.bonus_amount*self.available_quantity)
  end

  def update_payment_if_payment_changed
    changed = self.quantity_changed? || self.amount_cents_changed? || self.service_id_changed?
    yield
    self.update_payment_amount! if changed
  end

  def has_amount_in_purse
    max_amount = self.purse.available_amount
    max_amount += self.payment.amount if self.persisted?
    errors.add(:amount, :no_amount_in_purse) if self.bonus_amount*quantity > max_amount
  end

  def complete_by_firm
    if self.firm.has_pro? || self.no_service?
      used_count = self.firm.purse_payment_certificates.where(source_payment_id: self.payment_id).count
      errors.add(:firm, :limit_is_exceeded) if self.available_quantity.zero? || used_count >= self.limit
    else
      errors.add(:firm, :no_base_pro)
    end
  end
end
