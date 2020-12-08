class AddSlugToFirmCatalogs < ActiveRecord::Migration
  def change
    add_column :firm_catalogs, :slug, :string
    add_index :firm_catalogs, :slug, unique: true
  end
end
