class CreateCityFirms < ActiveRecord::Migration

  def change
    create_table :city_firms do |t|
      t.integer :city_id
      t.integer :firm_id
      t.boolean :base, default: false, null: false

      t.timestamps
    end

    add_index :city_firms, :city_id
    add_index :city_firms, :firm_id
  end

end