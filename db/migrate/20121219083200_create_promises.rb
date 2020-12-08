class CreatePromises < ActiveRecord::Migration
  def change
    create_table :promises do |t|
      t.references :wishlist
      t.references :user
      t.string :description

      t.timestamps
    end
    add_index :promises, :wishlist_id
    add_index :promises, :user_id
  end
end
