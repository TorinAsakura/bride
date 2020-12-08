# encoding: utf-8
class Bonus::Service::AddCityDecorator < Draper::Decorator
  delegate_all

  def min_price(firm = h.current_firm)
    city = object.pro.city_ratios.order(:percent).first.city rescue nil
    amount = [object.price(firm, city),(object.pro.amount*12*object.coefficient(firm)).to_nice].compact.min
    "от #{amount.format(html:true)}/город".html_safe
  end

  def subscribe(firm = h.current_firm)
    h.link_to('Оплатить', h.new_bonus_service_subscription_path(object), class: 'link-style')
  end

  def pay_period
    ' на всегда'
  end

  def title
    'Покупка дополнительного города'
  end
  alias_method :active_title, :title

  def sub_title
    'Если ваша компания представлена в&nbsp;нескольких городах, то&nbsp;вы&nbsp;можете подлключить все необходимые вам города.<br/><br/>Оплата производится один раз и&nbsp;навсегда. <br/>После подключения города в&nbsp;разделе &laquo;Контакты&raquo; появится возможность указать адрес в&nbsp;новом городе. <br/>Так&nbsp;же информация о&nbsp;вашей компании будет доступна пользователям, кто готовится к&nbsp;свадьбе в&nbsp;данном городе.'.html_safe
  end
end
