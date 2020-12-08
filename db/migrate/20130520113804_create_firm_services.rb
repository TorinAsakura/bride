class CreateFirmServices < ActiveRecord::Migration
  def change
    create_table :firm_services do |t|
      t.references :firm
      t.string :name
      t.string :unit
      t.boolean :base, default: false, null: false
      t.integer :cost

      t.timestamps
    end
    add_index :firm_services, :firm_id
  end
end
