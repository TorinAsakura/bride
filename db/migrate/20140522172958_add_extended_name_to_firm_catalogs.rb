class AddExtendedNameToFirmCatalogs < ActiveRecord::Migration
  def change
    add_column :firm_catalogs, :extended_name, :string, default: ''
  end
end
