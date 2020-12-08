class FirmCatalogDecorator < Draper::Decorator
  delegate_all

  def category_name
    object.category.presence || object.parent.name
  end
end
