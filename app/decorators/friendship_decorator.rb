class FriendshipDecorator < Draper::Decorator
  delegate_all

  def link_to_avatar_small
    user.link_to_avatar_small
  end

  def small_avatar_image(css = nil)
    h.image_tag(user.client? ? user.avatar.small : user.logo.small, class: css)
  end

  def link_to_first_name
    client.link_to_first_name
  end

  def user
    object.user.decorate
  end

  def user_name
    user.name
  end

  def client
    object.user.client.decorate
  end

  def notification_by(client)
    h.link_to(h.friends_client_url(client), title: I18n.t('.title', scope: 'friendship.notification'), class: 'notif-item'){
      h.content_tag(:div, small_avatar_image('img-circle'), class: 'notif-img pull-left') +
          h.content_tag(:h3, user_name, class: 'notif-heading') +
          h.content_tag(:p, I18n.t('.common_friends', scope: 'friendship.notification', count: user.common_friends_count_with(client.user)), class: 'notif-text')
    } + h.content_tag(:div, notification_actions(client), class: 'list-actions')
  end

  def notification_actions(client)
    h.content_tag(:div, class: 'btn-group.btn-group-xs') {
      h.link_to(h.ion('checkmark'), h.confirm_client_invite_url(client, object), title: I18n.t('static.confirm'), class: 'btn-actions btn-ion btn-default', method: :post) +
          h.link_to(h.ion('eye'), h.reject_client_invite_url(client, object), title: I18n.t('static.hide'), class: 'btn-actions btn-ion btn-default', method: :put) +
          h.link_to(h.ion('close'), h.reject_client_invite_url(client, object), title: I18n.t('static.reject'), class: 'btn-actions btn-ion btn-default', method: :put)
    }
  end
end
