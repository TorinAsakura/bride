class MessageDecorator < Draper::Decorator
  delegate_all

  def header_link_to_user_avatar
    h.link_to(user.small_avatar_image, user.profile_url)
  end

  def user_small_avatar_image(css = nil)
    user.small_avatar_image(css)
  end

  def header_link_to_user_name
    h.link_to(user.name, user.profile_url)
  end

  def header_link_to_message
    h.link_to(h.message_url(object), class: 'message'){
      h.content_tag(:div, small_subject, class: 'subject') +
          h.content_tag(:div, object.body, class: 'body')
    }
  end

  def user
    object.user.decorate
  end

  def created_at
    I18n.l(object.created_at, format: :comment)
  end

  def small_subject
    h.substr(object.subject, 26)
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end