class AddRoleToUser < ActiveRecord::Migration
  def up
    # Fix 4 pg:
    #rename_column :users, :is_performer, :type_user
    #change_column :users, :type_user, :integer, :default => 0
    remove_column :users, :is_performer
    add_column	:users, :type_user, :integer, :default => 0
  end
  
  def down
    # Fix 4 pg:
    #rename_column :users, :type_user, :is_performer
    #change_column :users, :is_performer, :boolean, :default => false
    remove_column :users, :type_user
    add_column :users, :is_performer, :boolean, :default => false
  end
end
