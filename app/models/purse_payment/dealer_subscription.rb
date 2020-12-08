class PursePayment::DealerSubscription < PursePayment::Withdrawal
  has_one :dealer_transfer_payment, class_name: 'PursePayment::DealerTransferSubscription', foreign_key: :source_payment_id #Куда
  has_one :subscription, class_name: 'Bonus::Subscription', as: :payment

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
                              duration: self.subscription.decorate.duration,
                              firm: self.target.name) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              firm: self.target.name,
                              period: self.subscription.decorate.period,
                              id: self.id) if self.description.blank?
    self.save
  end

  def action_after_complete
    params = {
        source_purse: self.purse,
        purse: self.target.purse,
        amount: -self.amount,
        source_payment: self
    }
    payment = self.target.purse_payment_dealer_transfer_subscriptions.build(params)
    payment.save!
    payment.complete!
    super
  end
end