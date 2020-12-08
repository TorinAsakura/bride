class AddCoverIdToAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :cover_id, :integer
    add_index :photo_albums, :cover_id
  end
end


