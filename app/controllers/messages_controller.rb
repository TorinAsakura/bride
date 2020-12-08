# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :find_message, only: [:show, :destroy, :append]
  respond_to :js, :html

  def index
    @message_rooms = current_user.message_rooms
  end

  def show
    @recipient = @message.message_room.recipient(current_user)
    @messages = @message.message_room.messages.includes(:images)
    @messages.each do |message|
      message.read! if !current_user.my_message?(message) && !message.read?
    end

    respond_to do |format|
      format.js {}
    end
  end

  def new
    @message = Message.new(recipient_id: params[:user_id])

    respond_with @message
  end

  def create
    @recipient = User.find(params[:message][:recipient_id])
    @message = current_user.send_message(@recipient)
    @message_form = MessageForm.new(@message)

    respond_to do |format|
      if @message_form.submit(params[:message])
        format.json { render json: { images_url: message_images_path(@message),
                                     message_url: append_message_path(@message) } }
        format.html { redirect_to messages_path }
      else
        format.json
      end
    end
  end

  def destroy
    @message.destroy
  end

  def append; end

  private
  def find_message
    @message = Message.find(params[:id])
  end
end
