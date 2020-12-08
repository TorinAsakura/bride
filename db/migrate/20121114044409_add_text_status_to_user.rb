class AddTextStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :text_status, :string, :limit => 255
  end
end
