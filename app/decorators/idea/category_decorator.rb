class Idea::CategoryDecorator < Draper::Decorator
  delegate_all

  def image_bg
    bg = object.image.url(:thumb)
    gray_bg = object.image.url(:gray_thumb)
    active = (user = h.current_user).present? && !user.user_ideas.where(category_id: object.id).count.zero?
    {
        'bg'       => bg,
        'gray-bg'  => gray_bg,
        'active'   => active && active.to_s,
        'id'       => h.dom_id(object)
    }
  end

  def filter_class
    object.sections.decorate.map(&:filter_name).join(' ')
  end

  def site_category_url(site)
    owner = site.user
    if (user = h.current_user).present? && user.is?(owner) && owner.user_ideas.where(category_id: object.id).count.zero?
      h.idea_section_category_url(object.sections.first, object)
    else
      h.minisite_my_ideas_category_path(object)
    end
  end

  def site_image_bg(site)
    owner = site.user
    active = (user = h.current_user).present? && user.is?(owner) && !owner.user_ideas.where(category_id: object.id).count.zero?
    bg = object.image.url(:preview)
    gray_bg = object.image.url(:gray_preview)
    {
        'bg'       => bg,
        'gray-bg'  => gray_bg,
        'active'   => active && active.to_s,
        'id'       => h.dom_id(object)
    }
  end
end
