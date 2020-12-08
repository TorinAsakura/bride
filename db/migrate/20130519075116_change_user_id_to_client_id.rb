class ChangeUserIdToClientId < ActiveRecord::Migration
  def change
  	add_column :polls, :client_id, :int
  	rename_column :programms, :user_id, :client_id
  	rename_column :promises, :user_id, :client_id
  	rename_column :wishlists, :user_id, :client_id
  	rename_column :users_weddings_roles, :user_id, :client_id  	
  	rename_column :sites, :user_id, :client_id
  end
end
