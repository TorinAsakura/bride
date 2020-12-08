class ChangeQuestionCategory < ActiveRecord::Migration
  def up
    drop_table :communities_question_categories
    remove_column :questions, :community_id
    add_column :question_categories, :community_id, :integer
    add_index :question_categories, :community_id
  end

  def down
    remove_index :question_categories, :community_id
    remove_column :question_categories, :community_id
    add_column :questions, :community_id, :integer
    add_index :questions, :community_id
    create_table :communities_question_categories, :id => false do |t|
        t.references :community
        t.references :question_category
    end
  end
end
