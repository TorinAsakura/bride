class RenameTableIdeas < ActiveRecord::Migration
  def change
    rename_table :ideas, :idea_ideas
  end
end
