class AddIsFreezeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :is_freeze, :boolean, :default => false
  end
end
