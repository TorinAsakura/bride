class AddSlugToSubscriptionService < ActiveRecord::Migration
  def change
    add_column :subscription_services, :slug, :string
  end
end
