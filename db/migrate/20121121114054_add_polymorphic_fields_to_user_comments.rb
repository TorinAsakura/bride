class AddPolymorphicFieldsToUserComments < ActiveRecord::Migration
  def change
    add_column :user_comments, :commentable_id, :integer
    add_column :user_comments, :commentable_type, :string
    
    add_index :user_comments, [:commentable_id, :commentable_type]
  end
end
