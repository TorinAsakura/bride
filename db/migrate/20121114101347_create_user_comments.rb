class CreateUserComments < ActiveRecord::Migration
  def change
    create_table :user_comments do |t|
      t.references :user
      t.references :parent
      t.text :body

      t.timestamps
    end
    add_index :user_comments, :user_id
    add_index :user_comments, :parent_id
  end
end
