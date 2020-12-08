class ReCreateTaskDepend < ActiveRecord::Migration
  def up
    drop_table :task_depends
    
    create_table :task_depends do |t|
      t.references :task, :parent
      t.integer :parent_id
      t.timestamps
    end
    add_index :task_depends, :task_id
    add_index :task_depends, :parent_id
  end
 
  def down
    drop_table :task_depends
    
    create_table :task_depends, :id => false do |t|
      t.references :task
      t.integer :parent_id
      t.timestamps
    end
    add_index :task_depends, :task_id
  end
end
