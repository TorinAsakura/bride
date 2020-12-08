class AddCachedVotesColumnToSite < ActiveRecord::Migration
  def change
    add_column :sites, :cached_votes_up, :integer, default: 0
    add_index  :sites, :cached_votes_up
  end
end
