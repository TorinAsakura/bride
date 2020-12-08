class UserHaveAndBelongsToManyRooms < ActiveRecord::Migration
  def self.up
    create_table :message_rooms_users, :id => false do |t|
      t.references :user, :message_room
    end
    
    add_index :message_rooms_users, :user_id
    add_index :message_rooms_users, :message_room_id
  end
 
  def self.down
    drop_table :message_rooms_users
  end
end
