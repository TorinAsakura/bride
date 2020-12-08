class Idea::SectionDecorator < Draper::Decorator
  delegate_all

  def image_bg
    bg = object.image.url(:thumb)
    gray_bg = object.image.url(:gray_thumb)
    active = (user = h.current_user).present? && !user.user_ideas.joins(category: :sections).where('idea_categories_sections.section_id = ?', object.id).count.zero?
    {
        'bg'       => bg,
        'gray-bg'  => gray_bg,
        'active'   => active && active.to_s,
        'id'       => h.dom_id(object)
    }
  end

  def filter_name
    I18n.transliterate(object.name).downcase.tr(' ', '_')
  end
end
