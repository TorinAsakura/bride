class CreateUsersWeddingsRoles < ActiveRecord::Migration
  def up
    create_table :users_weddings_roles, :id => false do |t|
      t.references :role, :user, :wedding
    end
    
    add_index :users_weddings_roles, [:role_id, :user_id, :wedding_id], :unique => true, :name => 'roles_index'
  end

  def down
    drop_table :users_weddings_roles
  end
end
