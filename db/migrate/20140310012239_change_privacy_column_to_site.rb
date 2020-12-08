class ChangePrivacyColumnToSite < ActiveRecord::Migration
  def up
   remove_column :sites, :privacy
   add_column :sites, :privacy, :integer, default: 0
  end

  def down
   remove_column :sites, :privacy
   add_column :sites, :privacy, :string
  end
end
