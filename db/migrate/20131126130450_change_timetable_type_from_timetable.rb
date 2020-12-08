class ChangeTimetableTypeFromTimetable < ActiveRecord::Migration
  def change
    rename_column :timetables, :timetable_type, :t_type
  end
end
