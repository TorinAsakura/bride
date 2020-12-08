class DropCommunitiesUsersTable < ActiveRecord::Migration
  def up
    drop_table :communities_users
  end

  def down
    create_table :communities_users, id: false do |t|
      t.belongs_to :communities
      t.belongs_to :user
    end    
  end
end
