class PursePayment::SystemCertificateSubscription < PursePayment::Deposit
  belongs_to :source_payment, class_name: 'PursePayment::CertificateSubscription' #Откуда

  delegate :subscription, :certificate, to: :source_payment

  class << self
    def system?
      true
    end

    def in_filter?
      true
    end
  end

  private
  def add_details
    self.name        = self.source_payment.name        if self.name.blank?
    self.description = self.source_payment.description if self.description.blank?
    self.save
  end
end