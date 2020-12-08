class AddAvatarToClients < ActiveRecord::Migration
  def change
    add_column :clients, :avatar, :string
    remove_column :users, :avatar
  end
end
