class DropComminityMembersAddCreateCommunitiesUsers < ActiveRecord::Migration
  def up
    create_table :communities_users, :id => false do |t|
      t.references :user
      t.references :community
    end
  
    add_index :communities_users, [:user_id, :community_id], :unique => true
  end

  def down
    drop_table :communities_users
  end
end
