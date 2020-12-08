class AddDescriptionToAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :description, :text
  end
end
