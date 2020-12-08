class AddQuestionCategoryIdToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :question_category_id, :integer
    add_index :questions, :question_category_id
  end
end
