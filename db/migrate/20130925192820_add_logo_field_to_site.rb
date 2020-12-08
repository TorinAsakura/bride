class AddLogoFieldToSite < ActiveRecord::Migration
  def change
    add_column :sites, :logo, :string, default: nil
  end
end
