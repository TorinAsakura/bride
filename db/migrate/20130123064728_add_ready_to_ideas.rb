class AddReadyToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :ready, :boolean, :null => false, :default => false
  end
end
