class AddDeltaColumnToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :delta, :boolean, :default => true, :null => false
  end
end
