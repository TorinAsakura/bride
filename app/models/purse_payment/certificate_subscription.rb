class PursePayment::CertificateSubscription < PursePayment::Withdrawal
  belongs_to :source_payment, class_name: 'PursePayment::CertificateTransfer' #Откуда
  has_one    :system_payment, class_name: 'PursePayment::SystemCertificateSubscription', foreign_key: :source_payment_id #Куда

  has_one :subscription, class_name: 'Bonus::Subscription', as: :payment
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
                              name: self.subscription.service.name) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              certificate: self.certificate.name,
                              number: self.certificate.number) if self.description.blank?
    self.save
  end

  def action_after_complete
    system_params = {
        source_purse: self.purse,
        amount: -self.amount,
        source_payment: self
    }
    system_payment = self.target.purse_payment_system_certificate_subscriptions.build(system_params)
    system_payment.save!
    system_payment.complete!
    super
  end

end