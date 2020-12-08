class AddDescriptionColumnToIdeaCategory < ActiveRecord::Migration
  def change
    add_column :idea_categories, :description, :text
  end
end
