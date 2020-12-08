class PursePayment::Withdrawal < PursePayment
  # All PursePayments With withdrawal in purse
  private
  def reverse_amount
    self.amount = -self.amount
    self.save(validate: false)
  end
end