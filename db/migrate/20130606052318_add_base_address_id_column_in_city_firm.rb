class AddBaseAddressIdColumnInCityFirm < ActiveRecord::Migration
  def up
  	add_column :city_firms, :base_address_id, :integer
  end

  def down
  	remove_column :city_firms, :base_address_id
  end
end