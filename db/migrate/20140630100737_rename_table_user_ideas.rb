class RenameTableUserIdeas < ActiveRecord::Migration
  def change
    rename_table :user_ideas, :idea_user_ideas
    rename_column :idea_user_ideas, :idea_category_id, :category_id
  end
end
