class PursePayment::TransferSubscription < PursePayment::Withdrawal
  belongs_to :source_payment, class_name: 'PursePayment::DealerTransferSubscription' #Откуда
  has_one    :system_payment, class_name: 'PursePayment::SystemDealerSubscription', foreign_key: :source_payment_id #Куда

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
    system_params = {
        source_purse: self.purse,
        amount: -self.amount,
        source_payment: self
    }
    system_payment = self.target.purse_payment_system_dealer_subscriptions.build(system_params)
    system_payment.save!
    system_payment.complete!
    super
  end
end