class AddSystemToPhotoAlbums < ActiveRecord::Migration
  def change
    add_column :photo_albums, :system, :boolean, :default => false
  end
end
