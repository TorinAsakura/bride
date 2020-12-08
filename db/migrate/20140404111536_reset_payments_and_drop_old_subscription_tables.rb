class ResetPaymentsAndDropOldSubscriptionTables < ActiveRecord::Migration
  def up
    change_column_default :purses, :deposit_discount, 1
    rename_column :purses, :deposit_discount, :deposit_course
    Purse.update_all(amount_cents: 0, deposit_course: 1)
    ActiveRecord::Base.connection.execute("TRUNCATE payments")
    ActiveRecord::Base.connection.execute("TRUNCATE purse_payments")
    %w(
      subscription_services
      subscription_prices
      subscription_signing_services
      subscriptions
      subscription_rewards
      subscription_reward_transfers
    ).each do |table_name|
      drop_table table_name         if table_exists?(table_name)
    end

  end

  def down
    change_column_default :purses, :deposit_course, 0
    rename_column :purses, :deposit_course, :deposit_discount
  end
end
