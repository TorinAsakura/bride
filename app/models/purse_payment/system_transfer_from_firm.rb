class PursePayment::SystemTransferFromFirm < PursePayment::Deposit
  belongs_to :source_payment, class_name: 'PursePayment::TransferToSystem'

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
    self.name = I18n.t('name', scope: self.class.translate_scope, firm: self.target.name) if self.name.blank?
    self.save
  end
end