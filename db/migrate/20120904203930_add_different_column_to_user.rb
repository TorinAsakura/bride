class AddDifferentColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :phone, :string
    add_column :users, :vk, :string
    add_column :users, :fb, :string
    add_column :users, :tw, :string
    add_column :users, :mailru, :string
  end
end
