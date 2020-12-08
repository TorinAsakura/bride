class AddPriorityToIdeaCategories < ActiveRecord::Migration
  def change
    add_column :idea_categories, :priority, :integer, default: 0
  end
end
