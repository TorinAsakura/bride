class RenamePhotoPathToUsualPath < ActiveRecord::Migration
  def up
  	rename_column :photos, :path, :usual_path
  end

  def down
  	rename_column :users, :usual_path, :path
  end
end
