class AddNestedSetToFirmCatalogs < ActiveRecord::Migration
  def change
    add_column :firm_catalogs, :lft, :integer
    add_column :firm_catalogs, :rgt, :integer
    add_column :firm_catalogs, :depth, :integer
    add_column :firm_catalogs, :children_count, :integer
  end
end
