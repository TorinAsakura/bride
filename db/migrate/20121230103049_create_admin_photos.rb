class CreateAdminPhotos < ActiveRecord::Migration
  def change
    create_table :admin_photos do |t|
      t.string :path
      t.text :description

      t.timestamps
    end
  end
end
