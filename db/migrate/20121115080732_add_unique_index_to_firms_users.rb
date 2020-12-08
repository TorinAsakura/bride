class AddUniqueIndexToFirmsUsers < ActiveRecord::Migration
  def change
    add_index :firms_users, [:firm_id, :user_id], :unique => true
  end
end
