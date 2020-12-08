class RemoveIdeaCategoryIdColumnFromIdea < ActiveRecord::Migration
  def up
  	remove_index :ideas, :idea_category_id
  	remove_column :ideas, :idea_category_id
  end

  def down
  	add_column :ideas, :idea_category_id, :index
  	add_index :ideas, :idea_category_id
  end
end
