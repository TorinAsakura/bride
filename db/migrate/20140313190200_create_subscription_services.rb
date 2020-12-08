class CreateSubscriptionServices < ActiveRecord::Migration
  def change
    create_table :subscription_services do |t|
      t.string   :name
      t.text     :description
      t.integer  :amount_cents,            default: 0
      t.integer  :min_dealer_amount_cents, default: 0
      t.integer  :duration
      t.string   :state
      t.boolean  :trial,                   default: false
      t.string   :identifier
      t.boolean  :pay_once,                default: false
      t.integer  :percent,                 default: 0
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :subscription_services, :identifier
    add_index :subscription_services, :state
    add_index :subscription_services, [:state, :trial]
    add_index :subscription_services, :deleted_at
  end
end
