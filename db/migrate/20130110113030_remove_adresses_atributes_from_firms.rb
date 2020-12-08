class RemoveAdressesAtributesFromFirms < ActiveRecord::Migration
  def up
    remove_column :firms, :country
    remove_column :firms, :region
    remove_column :firms, :city
  end

  def down
    add_column :firms, :country, :string
    add_column :firms, :region, :string
    add_column :firms, :city, :string
  end
end
