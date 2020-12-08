class AddSizeToIdeaCategories < ActiveRecord::Migration
  def change
    add_column :idea_categories, :width,  :integer, :null => false, :default => 0
    add_column :idea_categories, :height, :integer, :null => false, :default => 0
  end
end
