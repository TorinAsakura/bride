class AddInitialAlbumIdToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :initial_album_id, :integer
    Photo.all.each do |photo|
      photo.update_attribute(:initial_album_id, photo.album.id) unless photo.initial_album_id
    end
  end

  def down
    remove_column :photos, :initial_album_id
  end
end
