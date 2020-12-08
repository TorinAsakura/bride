module BonusServiceConcern
  extend ActiveSupport::Concern

  included do
    # Bonus Services
    has_many :bonus_subscriptions, class_name: 'Bonus::Subscription', as: :target# Payment

    has_many :bonus_signing_services, class_name: 'Bonus::SigningService', as: :target do # Services
      def service(service)
        where(bonus_signing_services: {service_id: service.id})
      end
    end

    # Оплата услуг
    has_many :purse_payment_subscriptions,                 class_name: 'PursePayment::Subscription',               as: :target # От пользователя
    has_many :purse_payment_system_subscriptions,          class_name: 'PursePayment::SystemSubscription',         as: :target # В Систему

    # Оплата услуг Диллером
    has_many :purse_payment_dealer_subscriptions,          class_name: 'PursePayment::DealerSubscription',         as: :target # От Диллера
    has_many :purse_payment_dealer_transfer_subscriptions, class_name: 'PursePayment::DealerTransferSubscription', as: :target # Пользователю
    has_many :purse_payment_transfer_subscriptions,        class_name: 'PursePayment::TransferSubscription',       as: :target # От пользователя
    has_many :purse_payment_system_dealer_subscriptions,   class_name: 'PursePayment::SystemDealerSubscription',   as: :target # В Систему

    # Сертификаты
    ## Услуги и монеты
    has_many :purse_payment_certificates,                     class_name: 'PursePayment::Certificate',                   as: :target # Оплата стоимости сертификата Диллером или Системой
    has_many :purse_payment_certificate_transfers,            class_name: 'PursePayment::CertificateTransfer',           as: :target # Зачисление сертификата пользователю
    ## Услуги
    has_many :purse_payment_certificate_subscriptions,        class_name: 'PursePayment::CertificateSubscription',       as: :target # От пользователя
    has_many :purse_payment_system_certificate_subscriptions, class_name: 'PursePayment::SystemCertificateSubscription', as: :target # В систему

  end

  module ClassMethods
  end

  def has_active_service?(service)
    (member_at = self.service_member(service)).present? && member_at >= Date.today
  end

  def service_member(service)
    self.send(service.member_method) rescue nil
  end

  def has_service?(service)
    self.service_member(service).present?
  end

  def signing_service(service)
    self.bonus_signing_services.service(service).first.try(:decorate)
  end

  def has_active_pro?
    has_active_service?(Bonus::Service.find('pro')) rescue false
  end

  def has_pro?
    has_service?(Bonus::Service.find('pro')) rescue false
  end

  def dealer_percent(city)
    if (pro = Bonus::Service::Pro.find('pro') rescue nil).present?
      percent = pro.city_dealer_percents.city(city).percent if city.present?
      percent ||= pro.dealer_percent
      percent
    else
      0
    end
  end
end
