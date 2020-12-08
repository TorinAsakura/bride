class CreateBonusPrices < ActiveRecord::Migration
  def change
    create_table :bonus_prices do |t|
      t.belongs_to :service
      t.belongs_to :firm_catalog
      t.integer :amount_cents, default: 0

      t.timestamps
    end
    add_index :bonus_prices, :service_id
    add_index :bonus_prices, :firm_catalog_id
  end
end
