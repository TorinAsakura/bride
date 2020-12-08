class AddCounterLikesToAlbums < ActiveRecord::Migration
  def self.up
    add_column :photo_albums, :cached_votes_up, :integer, :default => 0
    add_index  :photo_albums, :cached_votes_up
    Album.reset_column_information
    Album.all.each do |album|
      album.update_attribute :cached_votes_up, album.likes.length
    end
  end

  def self.down
    remove_column :photo_albums, :cached_votes_up
  end
end
