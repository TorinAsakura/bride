class AddPhoneColumnToUser < ActiveRecord::Migration
  def up
    add_column :users, :phone, :string
    remove_column :firms, :phone
    remove_column :clients, :phone
  end

  def down
    remove_column :users, :phone
    add_column :firms, :phone, :string
    add_column :clients, :phone, :string
  end
end
