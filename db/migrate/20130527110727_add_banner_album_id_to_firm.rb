class AddBannerAlbumIdToFirm < ActiveRecord::Migration
  def change
  	add_column :firms, :banner_album_id, :integer
  end
end
