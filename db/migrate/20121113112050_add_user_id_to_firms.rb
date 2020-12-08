class AddUserIdToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :user_id, :integer
  end
end
