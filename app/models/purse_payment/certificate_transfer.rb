class PursePayment::CertificateTransfer < PursePayment::Deposit
  belongs_to :source_payment, class_name: 'PursePayment::Certificate' #Откуда
  has_one    :subscription_payment, class_name: 'PursePayment::CertificateSubscription', foreign_key: :source_payment_id #Куда

  delegate :certificate, to: :source_payment

  class << self
    def blocked?
      true
    end

    def for_user?
      true
    end

    def system?
      false
    end
  end


  private
  def add_details
    self.name =        I18n.t('name',
                              scope: self.class.translate_scope,
                              name: self.certificate.name) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.certificate.name,
                              number: self.certificate.number,
                              description: self.certificate.decorate.payment_description) if self.description.blank?
    self.save
  end

  def action_after_complete
    if (service = certificate.service).present?
      firm = self.target
      signing_service = firm.bonus_signing_services.service(service).first
      firm.bonus_subscriptions.create(service: service, payer: certificate.owner, amount: certificate.bonus_amount, certificate: certificate, signing_service: signing_service )
    end
    super
  end
end