class AddParaniod < ActiveRecord::Migration
  def up
    # Recreate users uniq indexes
    remove_index :users, column: :email
    remove_index :users, column: :login
    add_index    :users, [:email, :deleted_at], unique: true
    add_index    :users, [:login, :deleted_at], unique: true

    add_column :firms,    :deleted_at, :datetime
    add_column :clients,  :deleted_at, :datetime
    add_column :roles,    :deleted_at, :datetime
    add_column :comments, :deleted_at, :datetime
  end

  def down
    remove_index :users, column: [:email, :deleted_at]
    remove_index :users, column: [:login, :deleted_at]
    add_index    :users, :email, unique: true
    add_index    :users, :login, unique: true

    remove_column :firms,    :deleted_at
    remove_column :clients,  :deleted_at
    remove_column :roles,    :deleted_at
    remove_column :comments, :deleted_at
  end
end
