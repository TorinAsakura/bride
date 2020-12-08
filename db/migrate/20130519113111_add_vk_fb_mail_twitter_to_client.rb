class AddVkFbMailTwitterToClient < ActiveRecord::Migration

  def up      
    remove_column :users, :vk
    add_column :clients, :vk, :string
    remove_column :users, :fb
    add_column :clients, :fb, :string
    remove_column :users, :tw
    add_column :clients, :tw, :string
    remove_column :users, :mailru
    add_column :clients, :mailru, :string
  end

  def down    
    add_column :users, :vk, :string
    remove_column :clients, :vk
    add_column :users, :fb, :string
    remove_column :clients, :fb
    add_column :users, :tw, :string
    remove_column :clients, :tw
    add_column :users, :mailru, :string
    remove_column :clients, :mailru
  end
  
end
