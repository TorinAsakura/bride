class AddCachedVotesToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :cached_votes_up, :integer, default: 0
    add_index :media_contents, :cached_votes_up
  end
end
