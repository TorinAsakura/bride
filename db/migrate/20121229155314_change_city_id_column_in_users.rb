class ChangeCityIdColumnInUsers < ActiveRecord::Migration
  def up
    change_column :users, :city_id, :integer, :null => false
  end

  def down
    change_column :users, :city_id, :integer, :null => false, :default => 1
  end
end
