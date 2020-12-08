class CreatePhotoAlbums < ActiveRecord::Migration
  def change
    create_table :photo_albums do |t|
      t.string :name
      t.references :resource, :polymorphic => true
      t.string :cover
      t.integer :count, :default => 0
      t.timestamps
    end
  end
end
