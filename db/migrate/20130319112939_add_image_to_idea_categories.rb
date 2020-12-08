class AddImageToIdeaCategories < ActiveRecord::Migration
  def change
    add_column :idea_categories, :image, :string
  end
end
