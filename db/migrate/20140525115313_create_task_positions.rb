class CreateTaskPositions < ActiveRecord::Migration
  def change
    create_table :task_positions do |t|
      t.belongs_to :task
      t.belongs_to :plan
      t.integer :position

      t.timestamps
    end
  end
end
