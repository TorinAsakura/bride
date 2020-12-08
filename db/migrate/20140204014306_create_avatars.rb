class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.references :client
    end
  end
end
