class CreateFirmCatalogTasks < ActiveRecord::Migration
  def change
    create_table :firm_catalog_tasks do |t|
      t.references :task
      t.references :firm_catalog

      t.timestamps
    end
    add_index :firm_catalog_tasks, :task_id
    add_index :firm_catalog_tasks, :firm_catalog_id
  end
end
