class CreateBonusRewards < ActiveRecord::Migration
  def change
    create_table :bonus_rewards do |t|
      t.references :payment, polymorphic: true
      t.belongs_to :referral
      t.belongs_to :dealer
      t.integer :amount_cents

      t.timestamps
    end
    add_index :bonus_rewards, [:payment_id, :payment_type], name: :bonus_rewards_payment_index
    add_index :bonus_rewards, :referral_id
    add_index :bonus_rewards, :dealer_id
  end
end
