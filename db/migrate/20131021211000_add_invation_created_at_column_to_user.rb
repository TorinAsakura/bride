class AddInvationCreatedAtColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitation_created_at, :date
  end
end
