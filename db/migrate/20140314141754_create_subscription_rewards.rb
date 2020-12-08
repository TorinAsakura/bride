class CreateSubscriptionRewards < ActiveRecord::Migration
  def change
    create_table :subscription_rewards do |t|
      t.references :purse_payment_target, polymorphic: true
      t.integer :amount_cents
      t.belongs_to :referral
      t.belongs_to :dealer

      t.timestamps
    end
    add_index :subscription_rewards, [:purse_payment_target_id, :purse_payment_target_type], name: :payment_index
    add_index :subscription_rewards, :referral_id
    add_index :subscription_rewards, :dealer_id
  end
end
