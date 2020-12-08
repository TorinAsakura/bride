class Payment::CashDeposit < Payment::Deposit
  register_currency :rub

  before_create :add_identifier

  private
  def add_identifier
    begin
      identifier = SecureRandom.urlsafe_base64(10)
    end while Payment::Deposit.find_all_by_identifier(identifier).nil?
    self.identifier = identifier if self.identifier.blank?
  end
end