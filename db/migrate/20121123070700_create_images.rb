class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :imageable, :polymorphic => true
      t.string :image
      t.string :type

      t.timestamps
    end
    add_index :images, [:imageable_id, :imageable_type]
    add_index :images, :type
  end
end
