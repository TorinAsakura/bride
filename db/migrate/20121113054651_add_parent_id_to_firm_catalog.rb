class AddParentIdToFirmCatalog < ActiveRecord::Migration
  def change
    add_column :firm_catalogs, :parent_id, :integer
  end
end
