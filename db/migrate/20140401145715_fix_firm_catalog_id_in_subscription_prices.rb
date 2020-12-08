class FixFirmCatalogIdInSubscriptionPrices < ActiveRecord::Migration
  def up
    rename_column :subscription_prices, :firm_catalog, :firm_catalog_id
  end

  def down
    rename_column :subscription_prices, :firm_catalog_id, :firm_catalog
  end
end
