class AddRaitingColumnToSphere < ActiveRecord::Migration
  def change
    add_column :spheres, :raiting, :integer, default: 0, null: false
  end
end
