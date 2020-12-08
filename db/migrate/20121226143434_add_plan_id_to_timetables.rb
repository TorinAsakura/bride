class AddPlanIdToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :plan_id, :integer
  end
end
