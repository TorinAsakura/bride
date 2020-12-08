class CreatePlansTasksForHabtm < ActiveRecord::Migration
  def change
    create_table(:plans_tasks, :id => false) do |t|
      t.references :plan
      t.references :task
    end
    add_index(:plans_tasks, [ :plan_id, :task_id ])
  end
end
