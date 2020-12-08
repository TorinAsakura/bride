class AddBannerPathColumnToPhoto < ActiveRecord::Migration
  def change
  	add_column :photos, :banner_path, :string
  end
end
