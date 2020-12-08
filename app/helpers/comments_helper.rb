# encoding: utf-8
module CommentsHelper
  def link_to_comment_author(comment)
    user = comment.user
    if user && user.firm?
      link_to user.firm.name, firm_link(user.firm)
    elsif user && user.client?
      link_to user.client.full_name, client_url(user.client)
    end
  end

  def link_to_parent_author(comment)
    user = comment.parent.user
    if user && user.firm?
      link_to user.firm.name, firm_link(user.firm)
    elsif user && user.client?
      link_to user.client.firstname, client_url(user.client)
    end
  end

  def author_name(comment)
    user = comment.user
    if user && user.firm?
      user.firm.name
    elsif user && user.client?
      user.client.firstname || ''
    end
  end

  def user_avatar(user)
    if user.nil?
      image_tag 'thumb_avatar.gif'
    else
      if client = user.client
        link_to(client_path(client.id)) { image_tag client.avatar.thumb }
      elsif firm = user.firm
        link_to(firm_link(firm)) { image_tag(firm.logo.thumb, size: '100x100', alt: "логотип #{firm.name}") }
      end
    end
  end

  def link_to_user(user)
    user.nil? ? 'Страница удалена' : link_to(user.name, user_path(user))
  end
end
