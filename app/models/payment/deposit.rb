class Payment::Deposit < Payment
  has_one :purse_payment_purse_deposit,      class_name: 'PursePayment::PurseDeposit',     as: :target
  has_one :purse_payment_system_deposit_fee, class_name: 'PursePayment::SystemDepositFee', as: :target
  register_currency :rub

  def payment_fee_amount
    nil
  end

  private
  def add_deposit_fee
    if (payment_fee_amount = self.payment_fee_amount).present? && self.purse_payment_system_deposit_fee.blank?
      payment = self.build_purse_payment_system_deposit_fee(amount: payment_fee_amount)
      payment.complete! if payment.save!
    end
  end

  def action_after_complete
    amount = self.amount.exchange_to('SVR')*self.user.purse.deposit_course
    deposit = self.build_purse_payment_purse_deposit(purse: self.user.purse, amount: amount)
    deposit.complete! if deposit.save!
    self.send(:add_deposit_fee)
  end

  def generate_token
    begin
      token = SecureRandom.random_number(10**9).to_s
    end while Payment.find_all_by_token(token).nil?
    self.token = token if self.token.blank?
  end
end