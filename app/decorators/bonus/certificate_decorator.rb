class Bonus::CertificateDecorator < Draper::Decorator
  delegate_all

  def payment_description
    if (service = self.object.service).present?
      "на \"#{service.name}\""
    else
      'для денежного бонуса'
    end
  end
end
