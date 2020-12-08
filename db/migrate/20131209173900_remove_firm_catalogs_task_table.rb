class RemoveFirmCatalogsTaskTable < ActiveRecord::Migration
  def up
  	drop_table :firm_catalogs_tasks
  end

  def down
   	create_table :firm_catalogs_tasks, id: false do |t|
      t.integer :firm_catalog_id
      t.integer :task_id
    end
  end
end
