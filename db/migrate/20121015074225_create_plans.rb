class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :script
      t.string :plan_type

      t.timestamps
    end
    add_index :plans, :script_id
  end
end
