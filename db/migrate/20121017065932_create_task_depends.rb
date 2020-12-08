class CreateTaskDepends < ActiveRecord::Migration
  def change
    create_table :task_depends, :id => false do |t|
      t.references :task
      t.integer :parent_id

      t.timestamps
    end
    add_index :task_depends, :task_id
  end
end
