class ChangeEventsColumns < ActiveRecord::Migration
  def up
    remove_column :events, :date_from
    remove_column :events, :wedding_id
    
    add_column :events, :timetable_id, :integer
    
    add_index :events, :timetable_id

    #remove_index :events, :wedding_id
    
  end

  def down
    add_column :events, :date_from, :date
    add_column :events, :wedding_id, :integer
    
    remove_index :events, :timetable_id
    remove_column :events, :timetable_id
    
    add_index :events, :date_from
    add_index :events, :wedding_id
  end
end

