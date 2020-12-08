class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user
      t.references :favoriteable, :polymorphic => true

      t.timestamps
    end
    add_index :favorites, :user_id
    add_index :favorites, [:favoriteable_id, :favoriteable_type]
  end
end
