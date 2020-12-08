class UpdateEventFromWeddingTask < ActiveRecord::Migration
  def up
    add_column :events, :task_id, :integer
  end

  def down
    remove_column :events, :task_id  
  end
end
