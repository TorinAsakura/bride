class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :description
      t.references :idea_category

      t.timestamps
    end
    add_index :ideas, :idea_category_id
  end
end
