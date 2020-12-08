class ReferenceSeatingPlanToSite < ActiveRecord::Migration
  def up
    remove_column :seating_plans, :wedding_id
    add_column :seating_plans, :site_id, :integer
  end

  def down
    remove_column :seating_plans, :site_id
    add_column :seating_plans, :wedding_id, :integer
  end
end
