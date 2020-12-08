class AddUserToGuestbook < ActiveRecord::Migration
  def change
    remove_column :guestbooks, :name
    add_column :guestbooks, :user_id, :integer
  end
end
