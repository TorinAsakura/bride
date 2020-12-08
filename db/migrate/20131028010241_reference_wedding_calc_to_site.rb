class ReferenceWeddingCalcToSite < ActiveRecord::Migration
  def up
    remove_column :wedding_calcs, :wedding_id
    add_column :wedding_calcs, :site_id, :integer
  end

  def down
    remove_column :wedding_calcs, :site_id
    add_column :wedding_calcs, :wedding_id, :integer
  end
end
