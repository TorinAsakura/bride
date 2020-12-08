class RenameWeddingIdeaSectionToIdeaSection < ActiveRecord::Migration
  def change
    rename_column :idea_categories_wedding_idea_sections, :wedding_idea_section_id, :idea_section_id
    rename_column :idea_category_tasks, :wedding_idea_section_id, :idea_section_id

    rename_table :wedding_idea_sections, :idea_sections
    rename_table :idea_categories_wedding_idea_sections, :idea_categories_idea_sections

    add_index "idea_category_tasks", ["idea_section_id"], name: "index_idea_category_tasks_on_idea_section_id"
  end
end
