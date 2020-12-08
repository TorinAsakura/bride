class AddBaseSphereIdColumnToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :base_sphere_id, :integer
  end
end
