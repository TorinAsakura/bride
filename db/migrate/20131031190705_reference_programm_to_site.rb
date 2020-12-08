class ReferenceProgrammToSite < ActiveRecord::Migration
  def up
    remove_column :programms, :wedding_id
    add_column :programms, :site_id, :integer
  end

  def down
    remove_column :programms, :site_id
    add_column :programms, :wedding_id, :integer
  end
end
