class AddCachedVotesColumnToClients < ActiveRecord::Migration
  def change
    add_column :clients, :cached_votes_up, :integer, default: 0
    add_index  :clients, :cached_votes_up
  end
end
