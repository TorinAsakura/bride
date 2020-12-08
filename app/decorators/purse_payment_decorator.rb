class PursePaymentDecorator < Draper::Decorator
  delegate_all

  def withdrawal
    amount = object.amount
    amount < 0 ? amount.format(symbol:false) : ''
  end

  def deposit
    amount > 0 ? amount.format(symbol:false) : ''
  end

  def created_at
    object.created_at.strftime("%d/%m/%y<br/>%H:%M").html_safe
  end

  def html_class
    case object.state
      when 'completed'
        'success'
      when 'failed'
        'error'
      else
        nil
    end
  end
end
