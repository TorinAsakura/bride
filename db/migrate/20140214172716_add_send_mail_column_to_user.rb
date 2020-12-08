class AddSendMailColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscription, :boolean
  end
end
