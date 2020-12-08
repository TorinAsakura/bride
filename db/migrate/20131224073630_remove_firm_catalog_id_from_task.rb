class RemoveFirmCatalogIdFromTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :firm_catalog_id
  end

  def down
    add_column :tasks, :firm_catalog_id, :integer
  end
end
