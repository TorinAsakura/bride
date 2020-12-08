module Access

  def for_admin(user = current_user)
    yield if user.present? && user.has_role?(:admin)
  end

  def for_moderator_of(resource, user = current_user)
    resource = resource.object if resource.decorated?
    if user.present? && user.has_any_role?(:admin, { name: :moderator, resource: resource }, { name: :owner, resource: resource })
      return block_given? ? yield : true
    end
    false
  end

  def for_member_of(resource, user = current_user)
    resource = resource.object if resource.decorated?
    if user.present? && user.has_any_role?(:admin, { name: :member, resource: resource }, { name: :owner, resource: resource })
      return block_given? ? yield : true
    end
    false
  end
end
