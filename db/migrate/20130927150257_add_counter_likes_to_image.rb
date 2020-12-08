class AddCounterLikesToImage < ActiveRecord::Migration
  def up
    add_column :images, :cached_votes_up, :integer, default: 0
    add_index :images, :cached_votes_up
  end

  def down
    remove_column :images, :cached_votes_up
  end
end
