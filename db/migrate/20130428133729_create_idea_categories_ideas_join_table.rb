class CreateIdeaCategoriesIdeasJoinTable < ActiveRecord::Migration
  def change
    create_table :idea_categories_ideas, :id => false do |t|
      t.integer :idea_category_id
      t.integer :idea_id
    end
  end
end
