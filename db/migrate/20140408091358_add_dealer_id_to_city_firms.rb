class AddDealerIdToCityFirms < ActiveRecord::Migration
  def change
    add_column :city_firms, :dealer_id, :integer
    add_index :city_firms, :dealer_id
  end
end
