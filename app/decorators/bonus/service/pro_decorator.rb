# encoding: utf-8
class Bonus::Service::ProDecorator < Draper::Decorator
  delegate_all

  def min_price(firm = h.current_firm)
    "#{object.price(firm).format(html:true)}/год".html_safe
  end

  def subscribe(firm = h.current_firm)
    active = firm.has_active_service?(object)
    s = ''
    if active
      s += firm.signing_service(object).available
    end
    unless active && object.pay_once?
      s += h.link_to(link_text(firm), h.new_bonus_service_subscription_path(object), remote: true, class: 'link-style')
    end
    s.html_safe
  end

  def by_header
    if h.current_firm.present?
      h.content_tag(:li, class: 'clearfix', id: 'header_'+h.dom_id(object)) do
        h.content_tag(:i, '', class: object.identifier)+
            h.content_tag(:p) do
              h.content_tag(:span, object.name+': ') +
                  h.link_to(link_text.downcase, h.new_bonus_service_subscription_path(object), remote: true, class: 'sv-link')
            end
      end
    end
  end

  def by_footer
    if h.current_firm.present?
      h.content_tag(:li, id: 'footer_'+h.dom_id(object)) do
        h.link_to(object.name, h.new_bonus_service_subscription_url(object), title: link_text.downcase, remote: true)
      end
    end
  end

  def link_text(firm = h.current_firm)
    active = firm.has_active_service?(object)
    signing = firm.has_service?(object)
    signing ? (active ? 'Продлить' : 'Подключить') : 'Попробовать'
  end

  def title
    'Подключение Pro аккаунта'
  end

  def active_title
    'Продление Pro аккаунта'
  end

  def subscription_description(subscription)
    descr = 'Услуга &laquo;PRO-аккаунт&raquo; открывает полный доступ к&nbsp;функциям сайта. Ваша страница станет доступна всем посетителям сайта <a href="/">Svadba.org</a> и&nbsp;люди смогут начать переписку с&nbsp;вашей компанией, оставлять отзывы, покупать товары и&nbsp;бронировать услуги, в&nbsp;каталоге компаний появится ваша визитка компании с&nbsp;расширенными данными и&nbsp;многое другое...'
    trial = subscription.signing_service.new_record? && object.trial?

    descr += "<br/><br/> Вам доступна возможность БЕСПЛАТНОГО пробного подключения услуги &laquo;PRO-аккаунт&raquo; на&nbsp;#{I18n.t("misc.days", count: object.trial_duration)}.<br/> Для активации бесплатной услуги нажмите на&nbsp;кнопку &laquo;Подключить&raquo;" if trial
    descr
  end
end
