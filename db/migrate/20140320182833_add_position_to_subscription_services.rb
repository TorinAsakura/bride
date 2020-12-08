class AddPositionToSubscriptionServices < ActiveRecord::Migration
  def change
    add_column :subscription_services, :position, :integer
    add_index :subscription_services, :position
  end
end
