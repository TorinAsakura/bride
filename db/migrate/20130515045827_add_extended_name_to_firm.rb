class AddExtendedNameToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :extended_name, :string
  end
end
