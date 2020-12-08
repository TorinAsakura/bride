class ChangeColumnsInAddress < ActiveRecord::Migration
  def up
  	remove_column :addresses, :firm_id
  	remove_column :addresses, :city_id
  	add_column :addresses, :city_firm_id, :integer
  	add_index :addresses, :city_firm_id
  end

  def down
  	add_column :addresses, :firm_id, :integer
  	add_column :addresses, :city_id, :integer
  	remove_index :addresses, :city_firm_id
  	remove_column :addresses, :city_firm_id
  end
end