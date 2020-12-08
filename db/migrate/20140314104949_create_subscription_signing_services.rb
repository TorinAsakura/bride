class CreateSubscriptionSigningServices < ActiveRecord::Migration
  def change
    create_table :subscription_signing_services do |t|
      t.belongs_to :service
      t.references :target, polymorphic: true
      t.date :starts_at
      t.date :ends_at

      t.timestamps
    end
    add_index :subscription_signing_services, :service_id
    add_index :subscription_signing_services, [:target_id, :target_type], name: :target_index
  end
end
