class RenameIdeaColumns < ActiveRecord::Migration
  def change
    rename_column :idea_ideas,          :idea_collection_id, :collection_id
    rename_column :idea_categories,     :idea_collection_id, :collection_id
    rename_column :idea_categories,     :priority,           :position
    rename_column :idea_sections,       :priority,           :position
    rename_column :idea_category_tasks, :idea_category_id,   :category_id
    rename_column :idea_category_tasks, :idea_section_id,    :section_id
  end
end
