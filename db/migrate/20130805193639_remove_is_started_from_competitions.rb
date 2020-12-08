class RemoveIsStartedFromCompetitions < ActiveRecord::Migration
  def up
    remove_column :competitions, :is_started
  end

  def down
    add_column :competitions, :is_started, :boolean, default: false
  end
end
