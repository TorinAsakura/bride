class RenameSeatingPlansTable < ActiveRecord::Migration
  def up
    rename_index :seating_plans, :index_seating_plans_on_site_id, :index_site_id
    rename_table :seating_plans, :old_seating_plans
    create_table :seating_plans do |t|
      t.belongs_to :site
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :seating_plans, :site_id
  end

  def down
    drop_table :seating_plans
    rename_table :old_seating_plans, :seating_plans
    rename_index :seating_plans, :index_site_id, :index_seating_plans_on_site_id
  end
end
