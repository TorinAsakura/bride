class TaskHabtMfirmCatalogs < ActiveRecord::Migration
  def change
  	create_table :firm_catalogs_tasks, id: false do |t|
      t.integer :firm_catalog_id
      t.integer :task_id
    end
  end
end
