class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.string :timetable_type
      t.date :date_from
      t.references :wedding  
    end
    add_index :timetables, :wedding_id
  end
end
