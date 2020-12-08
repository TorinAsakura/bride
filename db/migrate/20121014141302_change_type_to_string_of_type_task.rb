class ChangeTypeToStringOfTypeTask < ActiveRecord::Migration
  def up
    change_column :tasks, :type_task, :string
  end
  def down
    remove_column :tasks, :type_task
    add_column :tasks, :type_task, :integer
  end
end
