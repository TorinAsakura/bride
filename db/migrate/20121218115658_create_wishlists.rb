class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.references :wedding
      t.references :user
      t.string :name
      t.text :description
      t.string :url
      t.boolean :wish, :null => false, :default => true

      t.timestamps
    end
    add_index :wishlists, :wedding_id
    add_index :wishlists, :user_id
  end
end
