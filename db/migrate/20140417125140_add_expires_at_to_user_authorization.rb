class AddExpiresAtToUserAuthorization < ActiveRecord::Migration
  def up
    change_table :user_authorizations do |t|
      t.string :expires_at
    end
  end

  def down
    change_table :user_authorizations do |t|
      t.remove :expires_at
    end
  end
end
