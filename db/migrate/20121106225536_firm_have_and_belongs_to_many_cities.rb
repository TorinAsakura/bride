class FirmHaveAndBelongsToManyCities < ActiveRecord::Migration
  def self.up
    create_table :cities_firms, :id => false do |t|
      t.references :firm, :city
    end
    
    add_index :cities_firms, :city_id
    add_index :cities_firms, :firm_id
    
    #remove_column :firms, :city_id
  end
 
  def self.down
    drop_table :cities_firms
    
    add_column :firms, :city_id, :integer
  end
end
