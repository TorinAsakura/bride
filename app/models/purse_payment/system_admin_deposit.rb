class PursePayment::SystemAdminDeposit < PursePayment::Withdrawal
  belongs_to :source_payment, class_name: PursePayment::AdminDeposit

  class << self
    def system?
      true
    end

    def in_filter?
      true
    end
  end
end