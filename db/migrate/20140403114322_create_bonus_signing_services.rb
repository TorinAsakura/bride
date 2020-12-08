class CreateBonusSigningServices < ActiveRecord::Migration
  def change
    create_table :bonus_signing_services do |t|
      t.belongs_to :service
      t.references :target, polymorphic: true
      t.date :starts_at
      t.date :ends_at
      t.date :loyalty_at

      t.timestamps
    end
    add_index :bonus_signing_services, :service_id
    add_index :bonus_signing_services, [:target_id, :target_type], name: :bonus_signing_services_target_index
  end
end
