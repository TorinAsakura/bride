class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.references :tag
      t.references :taggable, :polymorphic => true

      #t.timestamps
    end
    add_index :clouds, :tag_id
    add_index :clouds, [:taggable_id, :taggable_type]
  end
end
