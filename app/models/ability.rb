# encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all
      can [ :update, :moderators_by_email, :remove_avatar ], Community, id: Community.with_role(:moderator, user).map(&:id)
      can :write, Community, id: Community.with_role(:member, user).map(&:id)
      can :join_the_community, Community
    end

    user.roles.where(name: 'moderator').each do |role|
      if role.resource_type
        resource = role.resource_type.singularize.classify.constantize
        if role.resource_id
          can :moderate, resource.find(role.resource_id)
        else
          can :moderate, resource
        end
      end
    end

    can :destroy, Comment do |comment|
      comment.user.owner?(user) || (user.has_any_role? :admin, { name: :moderator, resource: comment.root_object },
                                                               { name: :owner, resource: comment.root_object })
    end
  end
end
