class FirmsDecorator < Draper::Decorator
  delegate_all

  def name
    decor.name
  end

  def bonus_color_class
    decor.bonus_color_class
  end

  def cutaway
    decor.cutaway
  end

  def phone
    decor.phone
  end

  def catalogs
    decor.catalogs
  end

  def decor
    object.decorate
  end
end
