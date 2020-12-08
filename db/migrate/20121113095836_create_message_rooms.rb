class CreateMessageRooms < ActiveRecord::Migration
  def change
    create_table :message_rooms do |t|
      t.integer :message_count

      t.timestamps
    end
  end
end
