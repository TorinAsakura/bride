class AddDescriptionColumnToWeddingIdeaSection < ActiveRecord::Migration
  def change
    add_column :wedding_idea_sections, :description, :text
  end
end
