class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :community
      t.references :user
      t.references :answer
      t.text :body
      
      t.timestamps
    end
    add_index :questions, :community_id
    add_index :questions, :user_id
    add_index :questions, :answer_id
  end
end
