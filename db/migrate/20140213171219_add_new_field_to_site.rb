class AddNewFieldToSite < ActiveRecord::Migration
  def change
    add_column :sites, :color, :string
  end
end
