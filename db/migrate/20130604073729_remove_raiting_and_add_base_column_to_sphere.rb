class RemoveRaitingAndAddBaseColumnToSphere < ActiveRecord::Migration
  def up
    add_column :spheres, :base, :boolean, default: false, null: false
    remove_column :spheres, :raiting
  end

  def down
  	add_column :spheres, :raiting, :integer, default: 0, null: false
  	remove_column :spheres, :base
  end
end
