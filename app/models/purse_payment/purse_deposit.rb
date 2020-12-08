class PursePayment::PurseDeposit < PursePayment::Deposit

  class << self
    def for_user?
      true
    end

    def in_filter?
      true
    end
  end

  private
  def add_details
    self.name = I18n.t('name', scope: self.class.translate_scope, payment_system: self.target.payment_system_name) if self.name.blank?
    self.description = I18n.t('description', scope: self.class.translate_scope, payment_system: self.target.payment_system_name, id: self.target.identifier).html_safe if self.description.blank?
    self.save
  end
end