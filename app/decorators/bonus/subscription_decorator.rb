# encoding: utf-8
class Bonus::SubscriptionDecorator < Draper::Decorator
  delegate_all
  def period
    if object.service.pay_once? || object.service.uniq_form?
      object.service.decorate.pay_period
    else
      " с #{I18n.l(object.starts_at, format: "%d.%m.%y")} по #{I18n.l(object.ends_at, format: "%d.%m.%y")}"
    end
  end

  def duration
    if (package = object.package).present?
      package.decorate.duration
    else
      object.service.decorate.pay_period
    end
  end

  def description
    if object.service.pro?
      descr = object.service.decorate.subscription_description(object)
    else
      trial = object.signing_service.new_record? && object.service.trial?
      package = object.package
      descr = "Для "
      descr += "БЕСПЛАТНОГО " if trial
      descr += "#{object.signing_service.active? ? object.signing_service.pay_once? ? 'оплаты' : 'продления': 'подключения'} услуги \"#{object.service.name}\", "
      descr += "стоимостью #{object.amount.format(html:true)} " unless trial
      descr += "на #{I18n.t("misc.days", count: object.service.trial_duration)} " if trial
      descr += package.decorate.duration if package.present?
      descr += "нажмите кнопку \"Подтвердить\""
    end
    descr.html_safe
  end

  def payment_description
    "\"#{object.signing_object.name}\"" if object.service.uniq_form? && object.signing_object.present?
  end
end