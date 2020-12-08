class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string, :limit => 32

    add_index :users, :login, :unique => true
  end
end
