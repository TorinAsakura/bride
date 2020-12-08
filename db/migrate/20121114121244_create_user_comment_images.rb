class CreateUserCommentImages < ActiveRecord::Migration
  def change
    create_table :user_comment_images do |t|
      t.string :image
      t.integer :user_comment_id
      t.timestamps
    end
    add_index :user_comment_images, :user_comment_id 
  end
end
