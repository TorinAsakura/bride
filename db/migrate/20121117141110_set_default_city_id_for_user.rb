class SetDefaultCityIdForUser < ActiveRecord::Migration
  def up
    change_column :users, :city_id, :integer, :default => 1
  end

  def down
    change_column :users, :city_id, :integer
  end
end
