class AddCounterCashPhotosToAlbums < ActiveRecord::Migration
  def self.up
    add_column :photo_albums, :photos_count, :integer, default: 0
    add_index  :photo_albums, :photos_count

    Album.reset_column_information
    Album.all.each do |album|
      Album.reset_counters album.id, :photos
    end
  end

  def self.down
    remove_column :photo_albums, :photos_count
  end
end
