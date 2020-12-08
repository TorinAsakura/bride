class PursePayment::Subscription < PursePayment::Withdrawal
  has_one :bonus_reward, as: :payment, class_name: 'Bonus::Reward'
  has_one :system_payment, class_name: 'PursePayment::SystemSubscription', foreign_key: :source_payment_id
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
    self.name        = I18n.t('name',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              duration: self.subscription.decorate.duration) if self.name.blank?
    self.description = I18n.t('description',
                              scope: self.class.translate_scope,
                              name: self.subscription.service.name,
                              description: self.subscription.decorate.payment_description,
                              period: self.subscription.decorate.period,
                              id: self.id) if self.description.blank?
    self.save
  end

  def action_after_complete
    system_params = {
        source_purse: self.purse,
        name: self.name,
        description: "#{self.description} (#{self.purse.user.name})",
        amount: -self.amount,
        source_payment: self
    }
    system_payment = self.target.purse_payment_system_subscriptions.build(system_params)
    system_payment.save!
    system_payment.complete!
    super
  end
end