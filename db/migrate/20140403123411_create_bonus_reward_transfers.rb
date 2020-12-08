class CreateBonusRewardTransfers < ActiveRecord::Migration
  def change
    create_table :bonus_reward_transfers do |t|
      t.belongs_to :dealer
      t.belongs_to :payer
      t.integer :amount_cents

      t.timestamps
    end
    add_index :bonus_reward_transfers, :dealer_id
    add_index :bonus_reward_transfers, :payer_id
  end
end
