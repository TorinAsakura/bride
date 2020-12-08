class PageDecorator < Draper::Decorator
  delegate_all

  def icon
    case object.name
      when 'about'
        'user'
      when 'albums'
        'picture'
      else
        'doc-alt'
    end
  end
end
