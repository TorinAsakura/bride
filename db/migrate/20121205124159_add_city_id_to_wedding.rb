class AddCityIdToWedding < ActiveRecord::Migration
  def change
    add_column :weddings, :city_id, :integer, :nil => false
    add_index :weddings, :city_id 
  end
end
