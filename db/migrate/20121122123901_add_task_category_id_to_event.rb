class AddTaskCategoryIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :task_category_id, :integer, :nil => false
    add_index :events, :task_category_id
  end
end
