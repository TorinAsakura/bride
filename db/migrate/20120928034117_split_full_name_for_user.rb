class SplitFullNameForUser < ActiveRecord::Migration
  def up
    rename_column :users, :full_name, :name
    add_column :users, :surname, :string
  end

  def down
    rename_column :users, :name, :full_name
    remove_column :users, :surname 
  end
end
