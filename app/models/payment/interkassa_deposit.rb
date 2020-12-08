class Payment::InterkassaDeposit < Payment::Deposit
  before_create :generate_token
  register_currency :rub

  def payment_fee_amount
    self.amount.exchange_to('SVR')*0.03 #3%
  end

  def payment_system_name
    payer_info = self.payer_id.try(:split, '_') || ['test', 'rub']
    pay_system   = I18n.t(payer_info.first, scope: 'payment.interkassa_deposit.payers')
    pay_currency = Money::Currency.find(payer_info.last).html_entity
    [super, pay_system, pay_currency].join(' ')
  end

  def update_pay_info!(params)
    self.payer_id = params[:pw_via]
    self.identifier = params[:inv_id]
  end

  def finish!(params)
    self.update_pay_info!(params)
    self.complete!
    self.purse_payment_purse_deposit.update_attribute(:params, params.except(:desc))
    self
  end

  def pending!(params)
    self.update_pay_info!(params)
    self.save
  end

  def close!(params)
    self.update_pay_info!(params)
    self.cancel!
    self
  end

  def name
    I18n.t('name', scope: 'payment.interkassa_deposit', payer: self.user.name, amount: self.amount.format)
  end
end