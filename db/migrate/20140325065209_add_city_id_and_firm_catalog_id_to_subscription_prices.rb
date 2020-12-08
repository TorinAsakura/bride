class AddCityIdAndFirmCatalogIdToSubscriptionPrices < ActiveRecord::Migration
  def change
    add_column :subscription_prices, :city_id, :integer
    add_column :subscription_prices, :firm_catalog, :integer
    add_index :subscription_prices, :city_id
    add_index :subscription_prices, :firm_catalog
    add_index :subscription_prices, [:city_id, :firm_catalog], name: :index_city_and_catalog
  end
end
