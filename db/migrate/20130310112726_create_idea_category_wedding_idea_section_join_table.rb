class CreateIdeaCategoryWeddingIdeaSectionJoinTable < ActiveRecord::Migration
  def change
    create_table :idea_categories_wedding_idea_sections do |t|
      t.integer :idea_category_id
      t.integer :wedding_idea_section_id
    end
  end
end
