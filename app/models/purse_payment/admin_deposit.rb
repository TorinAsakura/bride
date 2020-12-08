class PursePayment::AdminDeposit < PursePayment::Deposit
  has_one :system_payment, class_name: PursePayment::SystemAdminDeposit, foreign_key: :source_payment_id

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validate :has_amount_in_system_purse?, on: :create

  class << self
    def for_user?
      true
    end
  end

  private
  def add_details
    self.name = I18n.t('name', scope: self.class.translate_scope) if self.name.blank?
    self.description = I18n.t('description', scope: self.class.translate_scope, admin: self.target.name) if self.description.blank?
    self.save
  end

  def action_after_complete
    system_params = {
        source_purse: self.purse,
        name: self.name,
        description: self.description + "(#{self.user.name})",
        amount: -self.amount,
        source_payment: self
    }
    system_payment = self.target.purse_payment_system_admin_deposits.create!(system_params)
    system_payment.complete!
    super
  end

  def has_amount_in_system_purse?
    self.errors.add(:base, :no_amount_in_system_purse) if self.amount > PursePayment.system_amount
  end
end
