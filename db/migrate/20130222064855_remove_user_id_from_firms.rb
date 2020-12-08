class RemoveUserIdFromFirms < ActiveRecord::Migration
  def up
    remove_column :firms, :user_id
  end

  def down
    add_column :firms, :user_id, :integer
  end
end
