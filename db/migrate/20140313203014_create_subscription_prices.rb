class CreateSubscriptionPrices < ActiveRecord::Migration
  def change
    create_table :subscription_prices do |t|
      t.belongs_to :subscription_service
      t.belongs_to :dealer
      t.integer :amount_cents, default: 0

      t.timestamps
    end
    add_index :subscription_prices, :subscription_service_id
    add_index :subscription_prices, :dealer_id
  end
end
