class AddBackgroundImageToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :background_image_id, :integer
    add_column :firms, :background_picture, :string
  end
end
