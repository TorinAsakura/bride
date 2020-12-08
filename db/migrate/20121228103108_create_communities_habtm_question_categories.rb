class CreateCommunitiesHabtmQuestionCategories < ActiveRecord::Migration
  def up
    create_table :communities_question_categories, :id => false do |t|
        t.references :community
        t.references :question_category
    end
  end

  def down
    drop_table :communities_question_categories
  end
end
