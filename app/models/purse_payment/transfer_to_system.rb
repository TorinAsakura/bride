class PursePayment::TransferToSystem < PursePayment::Withdrawal
  validates :amount, numericality: { greater_than_or_equal_to: 10 }

  private
  def action_after_complete
    self.send(:reverse_amount)
    system_params = {
        source_purse: self.purse,
        description: self.description,
        amount: -self.amount,
        source_payment: self
    }
    system_payment = self.target.purse_payment_system_transfer_from_firms.build(system_params)
    system_payment.save!
    system_payment.complete!
    super
  end

  def add_details
    self.name = I18n.t('name', scope: self.class.translate_scope) if self.name.blank?
    self.description = I18n.t('description', scope: self.class.translate_scope, id: self.id) if self.description.blank?
    self.save
  end
end