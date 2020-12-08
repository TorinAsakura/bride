class RemoveBaseColumnInAddress < ActiveRecord::Migration
  def up
  	remove_column :addresses, :base
  end

  def down
  	remove_column :addresses, :base, :boolean, default: false, null: false
  end
end