class AddWorkingTimeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :working_time_start, :time
    add_column :addresses, :working_time_end, :time
  end
end
