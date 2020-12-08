class CreateSpheres < ActiveRecord::Migration
  def change
    create_table :spheres do |t|
      t.references :firm
      t.references :firm_catalog

      t.timestamps
    end
    add_index :spheres, :firm_id
    add_index :spheres, :firm_catalog_id
  end
end
