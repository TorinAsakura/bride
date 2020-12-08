class RemoveParentIdFromUserComments < ActiveRecord::Migration
  def up
    remove_index  :user_comments, :parent_id
    remove_column :user_comments, :parent_id
  end

  def down
    add_column :user_comments, :parent_id, :integer
    add_index :user_comments, :parent_id
  end
end
