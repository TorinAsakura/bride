class ChangeSystemInAlbumToInt < ActiveRecord::Migration
  def up
  	remove_column :photo_albums, :system
  	add_column :photo_albums, :system, :integer, :default => 0
  end

  def down
  	remove_column :photo_albums, :system
  	add_column :photo_albums, :system, :boolean, :default => false  	
  end
end
