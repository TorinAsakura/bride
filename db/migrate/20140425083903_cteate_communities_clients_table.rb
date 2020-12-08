class CteateCommunitiesClientsTable < ActiveRecord::Migration
  def up
    create_table :clients_communities, id: false do |t|
      t.belongs_to :community
      t.belongs_to :client
    end
  end

  def down
    drop_table :clients_communities
  end
end
