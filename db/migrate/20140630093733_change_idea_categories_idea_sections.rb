class ChangeIdeaCategoriesIdeaSections < ActiveRecord::Migration
  def change
    rename_table :idea_categories_idea_sections, :idea_categories_sections
    rename_column :idea_categories_sections, :idea_category_id, :category_id
    rename_column :idea_categories_sections, :idea_section_id,  :section_id
  end
end
