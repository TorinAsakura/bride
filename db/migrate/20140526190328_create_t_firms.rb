class CreateTFirms < ActiveRecord::Migration
  def change
    create_table :t_firms do |t|
      t.belongs_to :firm_catalog
      t.belongs_to :city
      t.string :name
      t.string :extended_name
      t.string :phone
      t.string :address
      t.integer :rating

      t.timestamps
    end
    add_index :t_firms, :firm_catalog_id
    add_index :t_firms, :city_id
    add_index :t_firms, [:city_id, :firm_catalog_id, :rating], name: :rating_index
  end
end
