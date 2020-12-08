class RemoveBaseAddressIdCityFirms < ActiveRecord::Migration
  def up
    remove_column :city_firms, :base_address_id
  end

  def down
    add_column :city_firms, :base_address_id, :integer
    add_index :city_firms, :base_address_id
  end
end
