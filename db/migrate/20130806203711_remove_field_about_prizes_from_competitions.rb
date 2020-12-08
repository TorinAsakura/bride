class RemoveFieldAboutPrizesFromCompetitions < ActiveRecord::Migration
  def up
    remove_column :competitions, :about_prizes
  end

  def down
    add_column :competitions, :about_prizes, :text, default: nil
  end
end
