class DeleteSocialAccount < ActiveRecord::Migration
  def change
    drop_table :social_accounts
  end
end
