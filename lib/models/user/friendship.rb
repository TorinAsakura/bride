module Models
  module User
    module Friendship
      extend ActiveSupport::Concern

      included do
        has_many :friendships
        has_many :friends, :through => :friendships, :source => :friend, :conditions => "friendships.status = 'accepted'"
        has_many :friendships_awaiting_acceptance, :conditions => "friendships.status = 'requested'", :class_name => 'Friendship', :foreign_key => :friend_id
      end

      module ClassMethods
      end

      module InstanceMethods

        def friends?(friend)
          friendship = self.friendship_for(friend)
          !!(friendship && friendship.accepted?)
        end

        def accept_friendship_with(friend)
          if (pendent = self.friendship_for(friend)).pending?
            requested = friend.friendship_for(self)

            ActiveRecord::Base.transaction do
              pendent.accept!
              requested.accept! unless requested.accepted?
            end
          # else
          #   # raise YouCanNotJudgeARequestFriendshipError
          end
        end

        def deny_friendship_with(friend)
          if (pendent = self.friendship_for(friend)).pending?
            ActiveRecord::Base.transaction do
              [self.friendship_for(friend), friend.friendship_for(self)].compact.each do |friendship|
                friendship.destroy if friendship
              end
            end
          # else
          #   raise YouCanNotJudgeARequestFriendshipError
          end
        end

        def remove_friendship_with(friend)
          ActiveRecord::Base.transaction do
            [self.friendship_for(friend), friend.friendship_for(self)].compact.each do |friendship|
              friendship.destroy if friendship
            end
          end
        end

        def be_friends_with(friend)
          # no user object
          return nil, Friendship::STATUS_FRIEND_IS_REQUIRED unless friend

          # should not create friendship if user is trying to add himself
          return nil, Friendship::STATUS_IS_YOU if self.is?(friend)

          # should not create friendship if users are already friends
          return nil, Friendship::STATUS_ALREADY_FRIENDS if self.friends?(friend)

          # retrieve the friendship request
          friendship = self.friendship_for(friend)

          # let's check if user has already a friendship request or have removed
          request = friend.friendship_for(self)

          # friendship has already been requested
          return nil, Friendship::STATUS_ALREADY_REQUESTED if friendship && friendship.requested?

          # friendship is pending so accept it
          if friendship && friendship.pending?
            ActiveRecord::Base.transaction do
              friendship.accept!
              request.accept!
            end

            return friendship, Friendship::STATUS_FRIENDSHIP_ACCEPTED
          end

          ActiveRecord::Base.transaction do
            # we didn't find a friendship, so let's create one!
            friendship = self.friendships.create(:friend_id => friend.id, :status => ::Friendship::FRIENDSHIP_REQUESTED, :requested_at => Time.now)

            # we didn't find a friendship request, so let's create it!
            request = friend.friendships.create(:friend_id => id, :status => ::Friendship::FRIENDSHIP_PENDING, :requested_at => Time.now)
          end

          return friendship, ::Friendship::STATUS_REQUESTED
        end

        def friendship_for(friend)
          self.friendships.first :conditions => {:friend_id => friend.id}
        end

        def grouped_friends(friends=self.friends)
          all = friends.map(&:profileable).group_by{|f| f.class.name}
          return all['Firm'], all['Client']
        end

        def common_friends(friend)
          (friend.friends&self.friends).drop_while{|f| f.profileable_type == 'Firm'}
        end
      end #this end of InstanceMethods module
    end
  end
end
