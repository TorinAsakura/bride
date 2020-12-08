# encoding: utf-8
class Bonus::Service::AddSphereDecorator < Draper::Decorator
  delegate_all

  def min_price(firm = h.current_firm)
    subcategory = Bonus::Service::AddSphere.find('add-subcategory')
    discount = subcategory.try(:discount)
    firm_catalog = object.pro.prices.order(:amount_cents).first.try(:firm_catalog)
    amounts = [(object.pro.amount*discount.to_f*12/100).to_nice]
    amounts.push (subcategory || object).price(firm, firm_catalog) if firm_catalog
    amount = amounts.compact.min
    "от #{amount.format(html:true)}/категорию".html_safe
  end

  def subscribe(firm = h.current_firm)
    h.link_to('Оплатить', h.new_bonus_service_subscription_path(object), class: 'link-style')
  end

  def pay_period
    ' на всегда'
  end

  def title
    'Покупка дополнительной категории'
  end
  alias_method :active_title, :title

  def sub_title
    'Если ваша компания реализует товары и&nbsp;услуги разных направлений и&nbsp;вам необходимо, чтобы компания была сразу в&nbsp;нескольких категориях в&nbsp;каталоге, тогда вы&nbsp;можете подлкючить все необходимые вам категории каталога.<br/><br/>Оплата производится один раз и&nbsp;навсегда.<br/>Информируем Вас, что стоимость годовой подписки PRO-аккаунта равна стоимости самой дорогой категории из&nbsp;тех, что вы&nbsp;активировали.<br/>Выбирайте категории осознанно. Если ваша деятельность вашей компании не&nbsp;связана с&nbsp;выбранными категориями, то&nbsp;администрация сайта оставляет за&nbsp;собой право отключать не&nbsp;профильные категории, без возврата средств.'.html_safe
  end
end
