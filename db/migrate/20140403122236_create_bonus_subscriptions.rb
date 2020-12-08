class CreateBonusSubscriptions < ActiveRecord::Migration
  def change
    create_table :bonus_subscriptions do |t|
      t.belongs_to :service
      t.belongs_to :user
      t.belongs_to :package
      t.belongs_to :payer
      t.belongs_to :signing_service
      t.references :target, polymorphic: true
      t.references :signing_object, polymorphic: true
      t.references :payment, polymorphic: true
      t.integer :amount_cents
      t.date :starts_at
      t.date :ends_at
      t.string :state
      t.boolean :pay_once

      t.timestamps
    end
    add_index :bonus_subscriptions, :service_id
    add_index :bonus_subscriptions, :user_id
    add_index :bonus_subscriptions, :package_id
    add_index :bonus_subscriptions, :payer_id
    add_index :bonus_subscriptions, :signing_service_id
    add_index :bonus_subscriptions, [:target_id, :target_type], name: :bonus_subscriptions_target_index
    add_index :bonus_subscriptions, [:signing_object_id, :signing_object_type], name: :bonus_subscriptions_signing_object_index
    add_index :bonus_subscriptions, [:payment_id, :payment_type], name: :bonus_subscriptions_payment_index
    add_index :bonus_subscriptions, :state
  end
end
