class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :subscription_service
      t.belongs_to :user
      t.belongs_to :payer
      t.references :target, polymorphic: true
      t.belongs_to :signing_service
      t.belongs_to :payment
      t.integer    :price_cents
      t.date       :starts_at
      t.date       :ends_at
      t.string     :state

      t.timestamps
    end
    add_index :subscriptions, :subscription_service_id
    add_index :subscriptions, :user_id
    add_index :subscriptions, :payer_id
    add_index :subscriptions, [:target_id, :target_type]
    add_index :subscriptions, :signing_service_id
    add_index :subscriptions, :payment_id
    add_index :subscriptions, :state
  end
end
