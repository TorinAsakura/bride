class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.references :wedding
      t.references :role
      t.boolean :gender, :default => false
      t.string :email
      t.integer :drink, :limit => 1

      t.timestamps
    end
    add_index :guests, :role_id
    add_index :guests, :wedding_id
  end
end
