class MessageRoomsController < ApplicationController
  respond_to :json

  def read
    @message_room = MessageRoom.find(params[:id])
    @message_room.make_all_messages_in_room_as_read!

    respond_with @message_room
  end
end
