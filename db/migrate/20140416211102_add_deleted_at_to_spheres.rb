class AddDeletedAtToSpheres < ActiveRecord::Migration
  def change
    add_column :spheres, :deleted_at, :datetime
  end
end
