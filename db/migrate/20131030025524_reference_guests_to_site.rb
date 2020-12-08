class ReferenceGuestsToSite < ActiveRecord::Migration
  def up
    remove_column :guests, :wedding_id
    add_column :guests, :site_id, :integer
  end

  def down
    remove_column :guests, :site_id
    add_column :guests, :wedding_id, :integer
  end
end
