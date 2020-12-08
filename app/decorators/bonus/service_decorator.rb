# encoding: utf-8
class Bonus::ServiceDecorator < Draper::Decorator
  delegate_all

  def min_price(firm = h.current_firm)
    p = object.nice_amount.format(html:true)
    p += '/месяц' unless object.pay_once?
    p.html_safe
  end

  def subscribe(firm = h.current_firm)
    active = firm.has_active_service?(object)
    signing = firm.has_service?(object)
    s = ''
    if active
      s += firm.signing_service(object).available
    end
    if object.pay_once?
      s += h.link_to('Оплатить', h.new_bonus_service_subscription_path(object), remote: true, class: 'link-style')
    else
      link_text = signing ? (active ? 'Продлить' : 'Подключить') : (!object.trial_duration.zero? && 'Попробовать')
      s += h.link_to(link_text, h.new_bonus_service_subscription_path(object), remote: true, class: 'link-style') if link_text
    end
    s.html_safe
  end

  def pay_period
    ' на месяц' unless object.pay_once?
  end

  def by_header
    if (firm = h.current_firm).present? && firm.has_active_pro?
      h.content_tag(:li, class: 'clearfix', id: 'header_'+h.dom_id(object)) do
        h.content_tag(:i, '', class: object.identifier)+
            h.content_tag(:p) do
              h.content_tag(:span, object.name+': ') +
                  h.link_to(link_text, h.new_bonus_service_subscription_path(object), remote: true, class: 'sv-link')
            end
      end
    end
  end

  def by_footer
    if (firm = h.current_firm).present? && firm.has_active_pro?
      h.content_tag(:li, id: 'footer_'+h.dom_id(object)) do
        h.link_to(object.name, h.new_bonus_service_subscription_url(object), title: link_text.downcase, remote: true)
      end
    end
  end

  def link_text(firm = h.current_firm)
    active = firm.has_active_service?(object)
    signing = firm.has_service?(object)
    signing ? (active ? 'продлить' : 'подключить') : 'попробовать'
  end

  def title
    'Подключение услуги'
  end

  def active_title
    'Продление услуги'
  end
end
