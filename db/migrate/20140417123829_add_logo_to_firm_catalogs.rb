class AddLogoToFirmCatalogs < ActiveRecord::Migration
  def change
    add_column :firm_catalogs, :logo, :string
  end
end
