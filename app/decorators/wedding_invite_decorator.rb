class WeddingInviteDecorator < Draper::Decorator
  delegate_all

  def small_avatar_image(css = nil)
    h.image_tag(user.avatar.small, class: css)
  end

  def user
    object.client.user.decorate
  end

  def user_name
    user.name
  end

  def notification_by(client)
    h.link_to(h.friends_client_url(client), title: I18n.t('.title', scope: 'wedding_invite.notification'), class: 'notif-item'){
      h.content_tag(:div, small_avatar_image('img-circle'), class: 'notif-img pull-left') +
          h.content_tag(:h3, user_name, class: 'notif-heading') +
          h.content_tag(:p, I18n.t('.common_friends', scope: 'friendship.notification', count: user.common_friends_count_with(client.user)), class: 'notif-text')
    } + h.content_tag(:div, notification_actions(client), class: 'list-actions')
  end

  def notification_actions(client)
    h.content_tag(:div, class: 'btn-group.btn-group-xs') {
      h.link_to(h.ion('checkmark'), h.confirm_client_invite_url(client, object), title: I18n.t('static.confirm'), class: 'btn btn-ion btn-default', method: :post) +
          h.link_to(h.ion('close'), h.reject_client_invite_url(client, object), title: I18n.t('static.reject'), class: 'btn btn-ion btn-default', method: :put)
    }
  end
end
