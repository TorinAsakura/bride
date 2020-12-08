# encoding: utf-8
class Bonus::SigningServiceDecorator < Draper::Decorator
  delegate_all

  def title
    service = object.service.decorate
    object.active? ? service.active_title : service.title
  end

  def sub_title
    object.service.decorate.sub_title
  end

  def available
    available = object.service.pay_once? ? 'Оплачено' : 'Доступно'
    available +='<br/>'
    available +='до ' unless object.service.pay_once?
    available +="#{object.ends_at.strftime('%d/%m/%y')}"
    available.html_safe
  end
end
