class ChangeBaseColumnInAddress < ActiveRecord::Migration
  def up
  	change_column :addresses, :base, :boolean, :null => false, :default => false
  end

  def down
  	change_column :addresses, :base, :boolean, :null => false, :default => true
  end
end
