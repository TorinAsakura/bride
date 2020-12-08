class AddCategoryToFirmCatalogs < ActiveRecord::Migration
  def change
    add_column :firm_catalogs, :category, :string
    add_index :firm_catalogs, :category
  end
end
