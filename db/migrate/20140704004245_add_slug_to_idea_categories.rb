class AddSlugToIdeaCategories < ActiveRecord::Migration
  def change
    add_column :idea_categories, :slug, :string
    add_index :idea_categories, :slug, unique: true
  end
end
