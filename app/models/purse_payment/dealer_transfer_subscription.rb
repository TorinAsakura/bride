class PursePayment::DealerTransferSubscription < PursePayment::Deposit
  belongs_to :source_payment, class_name: 'PursePayment::DealerSubscription' #Откуда
  has_one    :transfer_payment, class_name: 'PursePayment::TransferSubscription', foreign_key: :source_payment_id #Куда

  delegate :subscription, to: :source_payment

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
                              name: self.subscription.service.name,
                              duration: self.subscription.decorate.duration) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              dealer: self.subscription.payer.name,
                              period: self.subscription.decorate.period,
                              id: self.id) if self.description.blank?
    self.save
  end

  def action_after_complete
    params = {
        purse: self.target.purse,
        amount: -self.amount,
        source_payment: self
    }
    payment = self.target.purse_payment_transfer_subscriptions.build(params)
    payment.save!
    payment.complete!
    super
  end

end