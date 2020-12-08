class AddStateColumnToEvent < ActiveRecord::Migration
  def change
    add_column :events, :state, :integer, :default => 1
  end
end
