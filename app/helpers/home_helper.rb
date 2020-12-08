# encoding: utf-8
module HomeHelper
  def friend_action(user, css = nil)
    link_params = if current_client && user.client
                    {remove: 'Удалить из друзей', requested: 'Вы запросили дружбу', accept: 'Подтвердить', add: 'Добавить в друзья', deny: 'Отклонить'}
                  elsif current_client && user.firm
                    {remove: 'Я клиент', add: 'Стать клиентом'}
                  else
                    {}
                  end

    hash_params = {remote: true, method: :post, 'data-js' => "friend-action-#{user.id}", class: css}

    if link_params[:remove] && current_user.friends?(user)
      render (user.profileable_type == 'Firm' ? 'friendship/popover_firm' : 'friendship/popover_client'), layout: false, user: user

    elsif link_params[:requested] && current_user.friendship_for(user) && current_user.friendship_for(user).requested?
      content_tag :span, link_params[:requested], class: css

    elsif link_params[:accept] && link_params[:deny] && current_user.friendship_for(user) && current_user.friendship_for(user).pending?
      link_to(link_params[:accept], accept_friendship_path(user.id), hash_params) + "\n" +
          link_to(link_params[:deny], deny_friendship_path(user.id), hash_params)

    elsif link_params[:add] && !current_user.is?(user)
      link_to link_params[:add], add_to_my_friends_path(user.id), hash_params.merge(class: 'link-style')
    end
  end
end