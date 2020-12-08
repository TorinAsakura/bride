class CreateUserIdeas < ActiveRecord::Migration
  def change
    create_table :user_ideas do |t|
      t.references :user, :null => false
      t.references :idea, :null => false
      t.references :idea_category, :null => false
      t.boolean :cover, :null => false, :default => false
    end
    add_index :user_ideas, :user_id
    add_index :user_ideas, :idea_id
    add_index :user_ideas, :idea_category_id
  end
end
