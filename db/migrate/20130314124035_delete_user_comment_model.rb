class DeleteUserCommentModel < ActiveRecord::Migration
  def up
    drop_table :user_comments
  end

  def down
    create_table :user_comments do |t|
      t.integer :user_id
      t.text    :body
      t.integer :commentable_id
      t.string  :commentable_type

      t.timestamps
    end
  end
end
