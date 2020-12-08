# encoding: utf-8
class FriendshipController < ApplicationController
  before_filter do
    @friend = User.find(params[:id])
  end
  
  def add_to_my_friends
    current_user.be_friends_with(@friend)
    if current_client && @friend.firm
      @friend.accept_friendship_with(current_user)
    end
    render 'friendship/update'
  end

  def accept_friendship
    current_user.accept_friendship_with(@friend)
    render 'friendship/update'
  end

  def deny_friendship
    current_user.deny_friendship_with(@friend)
    render 'friendship/update'
  end

  def remove_friendship
    current_user.remove_friendship_with(@friend)
    render 'friendship/update'
  end
end
