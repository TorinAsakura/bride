class RemoveCompletedFromEvent < ActiveRecord::Migration
  def up
    remove_column :events, :completed
  end

  def down
    add_column :events, :completed, :boolean
  end
end
