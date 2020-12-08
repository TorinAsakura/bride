class AddCoordinatesToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :coordinates, :boolean, default: false
  end
end
