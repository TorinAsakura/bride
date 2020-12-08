class AddUrlToSocialAccounts < ActiveRecord::Migration
  def up
    add_column :social_accounts, :url, :string
  end

  def down
    remove_column :social_accounts, :url
  end
end
