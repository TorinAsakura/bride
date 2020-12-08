class AddHeaderImageAndBackgroundImageToSites < ActiveRecord::Migration
  def change
    add_column :sites, :header_image_id, :integer
    add_column :sites, :background_image_id, :integer
    add_column :sites, :header_picture, :string
    add_column :sites, :background_picture, :string
  end
end
