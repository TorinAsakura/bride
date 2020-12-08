class AddCityIdToFirm < ActiveRecord::Migration
  def up
    add_column :firms, :city_id, :integer, :nil => false
    add_index :firms, :city_id
    
    # how we can restore :cities_firms?
    drop_table :cities_firms
  end

  def down    
    create_table :cities_firms, :id => false do |t|
      t.references :firm, :city
    end
    
    remove_index :firms, :city_id
    remove_column :firms, :city_id
  end
end
