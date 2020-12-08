class AddPositionToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :position, :integer
  end
end
