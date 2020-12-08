class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.references :sphere
      t.string :name
      t.string :icon
      t.string :title
      t.string :unit

      t.timestamps
    end
    add_index :specifications, :sphere_id
  end
end
