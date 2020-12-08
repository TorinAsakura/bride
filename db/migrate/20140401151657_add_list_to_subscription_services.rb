class AddListToSubscriptionServices < ActiveRecord::Migration
  def change
    add_column :subscription_services, :list, :boolean, default: true
  end
end
