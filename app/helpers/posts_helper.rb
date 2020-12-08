# encoding: utf-8
module PostsHelper
  def link_to_sort(path, title, sort_column, is_default, klass = '')
    direction = (params[:sort_direction].nil? || params[:sort_direction] == 'desc') ? 'asc' : 'desc'

    fallback_column = is_default && params[:sort_column].nil?
    klass += (fallback_column || params[:sort_column] == sort_column) ? 'sv-posts-order-active' : ''
    klass += " sv-posts-order-#{direction == 'asc' ? 'desc' : 'asc'}" unless klass.empty?

    link_to title, path + "?sort_column=#{sort_column}&sort_direction=#{direction}", class: klass, remote: true
  end

  def path_to_post resource
    if request.url.include? 'admin'
      polymorphic_path([:admin, resource.journal.profileable, resource])
    elsif resource.is_resource? 'Community'
      polymorphic_path([resource.journal, resource])
    elsif request.subdomain.present?
      post_path(resource)
    else
      polymorphic_path([resource.journal.profileable, resource])
    end
  end

  def edit_path_to_post resource
    if resource.is_resource? 'Community'
      edit_polymorphic_path([resource.journal, resource])
    elsif request.subdomain.present?
      edit_post_path(resource)
    else
      edit_polymorphic_path([resource.journal.profileable, resource])
    end
  end

  def destroy_post_link resource
    if resource.is_resource? 'Community'
      polymorphic_path([resource.journal, resource])
    elsif request.subdomain.present?
      post_path(resource)
    else
      polymorphic_path([resource.journal.profileable, resource])
    end
  end

  def post_form_title resource
    if resource.post.is_resource? 'Community'
      resource.new_record? ? 'Новая запись в клубе' : 'Редактирование записи в клубе'
    else
      resource.new_record? ? 'Новая запись в журнал' : 'Редактирование записи в журнале'
    end
  end
end
