class AddPositionToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :position, :integer
    add_index :addresses, :position
  end
end
