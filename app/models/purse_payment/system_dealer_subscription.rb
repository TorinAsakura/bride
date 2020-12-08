class PursePayment::SystemDealerSubscription < PursePayment::Deposit
  belongs_to :source_payment, class_name: 'PursePayment::TransferSubscription' #Откуда

  delegate :subscription, to: :source_payment

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
    self.name =        I18n.t('name',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              firm: self.target.name,
                              dealer: self.subscription.payer.name,
                              duration: self.subscription.decorate.duration) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              firm: self.target.name,
                              dealer: self.subscription.payer.name,
                              description: self.subscription.decorate.payment_description,
                              period: self.subscription.decorate.period,
                              id: self.id) if self.description.blank?
    self.save
  end
end