class CreateSubscriptionRewardTransfers < ActiveRecord::Migration
  def change
    create_table :subscription_reward_transfers do |t|
      t.integer :amount_cents
      t.belongs_to :dealer
      t.belongs_to :payer

      t.timestamps
    end
    add_index :subscription_reward_transfers, :dealer_id
    add_index :subscription_reward_transfers, :payer_id
  end
end
