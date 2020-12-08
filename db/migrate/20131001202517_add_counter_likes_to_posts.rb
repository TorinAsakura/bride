class AddCounterLikesToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :cached_votes_up, :integer, default: 0
    add_index :posts, :cached_votes_up
  end

  def down
    remove_column :posts, :cached_votes_up
  end
end
