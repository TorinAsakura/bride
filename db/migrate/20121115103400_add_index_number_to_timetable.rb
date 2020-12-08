class AddIndexNumberToTimetable < ActiveRecord::Migration
  def change
    add_column :timetables, :index_number, :integer
  end
end
