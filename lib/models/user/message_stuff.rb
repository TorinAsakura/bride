module Models
  module User
    module MessageStuff
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :message_rooms
        has_many :messages
        has_many :sent_messages, :class_name => "Message"
        has_many :received_messages, :class_name => "Message", :foreign_key => :recipient_id
        has_many :unread_messages, :class_name => "Message", :foreign_key => :recipient_id, :conditions => "messages.read = false"
      end

      module ClassMethods
        #class methods write here
      end

      module InstanceMethods
        def send_message(recipient)
          self.transaction do
            if general_room(recipient).nil?
              message_room = MessageRoom.create
              self.message_rooms << message_room
              recipient.message_rooms << message_room
              message_room_id = message_room.id
            else
              message_room_id = general_room(recipient)
            end
            self.messages.new(message_room_id: message_room_id, recipient_id: recipient.id)
          end
        end

        def general_room(recipient)
          room_ids = (self.message_room_ids & recipient.message_room_ids)
          room_ids.first
        end

        def my_message?(message)
          self.id == message.user_id
        end

        def reply(message)
          my_message?(message) ? message.self_reply : message.reply
        end
      end
    end
  end
end
