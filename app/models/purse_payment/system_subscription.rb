class PursePayment::SystemSubscription < PursePayment::Deposit
  belongs_to :source_payment, class_name: 'PursePayment::Subscription'

  class << self
    def system?
      true
    end

    def in_filter?
      true
    end
  end

  private
  def action_after_complete
    self.send(:add_subscription_reward!)
    super
  end
end