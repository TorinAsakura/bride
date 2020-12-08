class PursePayment::PayCertificate < PursePayment::Withdrawal
  attr_accessible :certificate
  has_many :certificate_payments, class_name: 'PursePayment::Certificate', foreign_key: :source_payment_id #Куда
  has_one :certificate, class_name: 'Bonus::Certificate', foreign_key: :payment_id


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
                              name: self.certificate.name,
                              count: self.certificate.quantity) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.certificate.name,
                              count: self.certificate.quantity,
                              number: self.certificate.number,
                              description: self.certificate.decorate.payment_description) if self.description.blank?
    self.save
  end
end