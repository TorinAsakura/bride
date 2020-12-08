class CreateSeatingPlans < ActiveRecord::Migration
  def change
    create_table :seating_plans do |t|
      t.text    :tables
      t.integer :wedding_id
      t.timestamps
    end

    add_index :seating_plans, :wedding_id
  end
end
