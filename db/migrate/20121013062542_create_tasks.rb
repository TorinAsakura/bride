class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.references :task_category
      t.references :firm_catalog
      t.integer :type_task

      t.timestamps
    end
    add_index :tasks, :task_category_id
    add_index :tasks, :firm_catalog_id
  end
end
