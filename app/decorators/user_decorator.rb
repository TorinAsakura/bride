class UserDecorator < Draper::Decorator
  delegate_all

  def thumb_avatar_image
    h.image_tag(user.client? ? profile.avatar.thumb : profile.logo.thumb)
  end

  def small_avatar_image(css = nil)
    h.image_tag(user.client? ? profile.avatar.small : profile.logo.small, class: css)
  end

  def profile_url
    user.client? ? h.client_url(profile) : h.firm_link(profile)
  end

  def mini_site
    user.client? ? h.root_url(subdomain: client.site.name) : h.new_site_url
  end

  def link_to_avatar_thumb
    h.link_to(thumb_avatar_image, profile_url)
  end

  def link_to_avatar_small
    h.link_to(small_avatar_image, profile_url)
  end

  def link_to_name
    h.link_to(full_name, profile_url)
  end

  def full_name
    user.full_name.presence || profile.model_name.human
  end

  def profile
    object.profileable
  end

  def profile_class
    profile.class.to_s.downcase
  end

  def common_friends_count_with(friend)
    object.common_friends(friend).count
  end

  protected
  def user
    object
  end
end
