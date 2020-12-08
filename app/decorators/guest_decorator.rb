class GuestDecorator < Draper::Decorator
  delegate_all

  def edit_link
    h.link_to(h.icon('pencil'), h.edit_minisite_guest_path(object), remote: true)
  end

  def name
    if (user = object.user).present?
      user.decorate.link_to_name
    else
      object.name
    end
  end

  def remove_link(list = false)
    if object.new_record?
      h.link_to(h.icon('remove'), '#', class: 'remove-new-guest')
    elsif list
      h.link_to(h.icon('remove'), [:minisite, object], method: :delete, remote: true, confirm: I18n.t('static.are_you_sure'), title: I18n.t('static.remove'))
    else
      h.link_to(h.icon('remove'), [:minisite, object], remote: true, title: I18n.t('static.hide'))
    end
  end

  def status(name, owner)
    active = object.send(name)
    icon = status_icon(name, active)
    owner ? h.link_to(icon, h.confirm_minisite_guest_path(object, status: name), remote: true, method: :post) : icon
  end

  def status_icon(name, active)
    icon = active ? 'ok-circle' : 'circle-empty'
    h.icon(icon, '', class: name)
  end

  def gender_icon
    klass = object.gender ? 'groom' : 'bride'
    klass += ' gender'
    icon = object.gender ? 'male' : 'female'
    h.content_tag(:div, h.icon(icon), class: klass)
  end
end
