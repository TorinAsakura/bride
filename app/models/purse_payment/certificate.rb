class PursePayment::Certificate < PursePayment::Withdrawal
  attr_accessible :target

  belongs_to :source_payment, class_name: 'PursePayment::PayCertificate'
  has_one :certificate_transfer_payment, class_name: 'PursePayment::CertificateTransfer', foreign_key: :source_payment_id #Куда
  
  delegate :certificate, to: :source_payment

  scope :by_target, ->(target) {where(target_id: target.id, target_type: target.class.to_s)}

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
    params = {
        source_purse: self.purse,
        purse: self.target.purse,
        amount: -self.amount,
        source_payment: self
    }
    payment = self.target.purse_payment_certificate_transfers.build(params)
    payment.save!
    payment.complete!
    super
  end
end