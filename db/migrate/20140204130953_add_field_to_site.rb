class AddFieldToSite < ActiveRecord::Migration
  def change
    add_column :sites, :privacy, :string
    add_column :sites, :string, :string
  end
end
