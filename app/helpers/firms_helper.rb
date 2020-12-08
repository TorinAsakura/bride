# encoding: utf-8
module FirmsHelper
  def get_administrator_id
    role = Role.find_by_name('admin')
    su = role.system_users if role
    admin = su.first unless su.blank?
    return false unless admin
    return admin.id
  end

  def link_to_add_fields(name, f, association, folder)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{folder}#{association.to_s.singularize}_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields sv-add_item", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_firm_page(firm, firm_page)
    title = firm_page.name ? t("firm_page_names.#{firm_page.name}") : firm_page.title
    path = case firm_page.name
      when 'journal' then firm_posts_page_path
      when 'albums' then albums_path
      when 'videos' then firm_videos_path
      when 'comments' then firm_comments_page_path
      when 'addresses' then firm_addresses_path
      else firm_page_path(firm_page)
    end
    link = inner_link_to_firm_page(title, path)
    content_tag('li', class: current_page?(path) ? 'active' : nil) { link }
  end

  def inner_link_to_firm_page(title, path)
    link_to path do
      (title || 'Дополнительная страница').html_safe + content_tag('i', '', class: 'arr')
    end
  end
end
