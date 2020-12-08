class AddDefaultValueToEventsForCompleted < ActiveRecord::Migration
  def up
    change_column :events, :completed, :boolean, :nil => false, :default => false
  end

  def down
    change_column :events, :completed, :boolean
  end
end
