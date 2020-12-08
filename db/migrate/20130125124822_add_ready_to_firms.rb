class AddReadyToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :ready, :boolean, :null => false, :default => false
  end
end
