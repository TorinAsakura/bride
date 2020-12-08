class CreateTaskFiles < ActiveRecord::Migration
  def change
    create_table :task_files do |t|
      t.string :url
      t.references :task
      t.string :title
      
      t.timestamps
    end
    add_index :task_files, :task_id
  end
end